import 'package:dentiste/firebase_options.dart';
import 'package:dentiste/pages/appointment/appointment_controller.dart';
import 'package:dentiste/pages/appointment/appointment_page.dart';
import 'package:dentiste/pages/authentification/singup_page.dart';
import 'package:dentiste/pages/billing/billing_page.dart';
import 'package:dentiste/pages/parametre/parametre_controller.dart';
import 'package:dentiste/pages/parametre/parametre_page.dart';
import 'package:dentiste/pages/patient/patient_page.dart';
import 'package:dentiste/pages/scanFacture/scanFacture_page.dart';
import 'package:dentiste/pages/statistics/statistics_page.dart';
import 'package:dentiste/translations/LocaleString.dart';
import 'package:dentiste/pages/app_controller.dart';
import 'package:dentiste/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';
import 'translations/LocaleString.dart';
import 'pages/authentification/login_page.dart';
import 'pages/authentification/singup_page.dart';
import 'pages/home/home_page.dart';
import 'pages/patient/patient_page.dart';
import 'pages/appointment/appointment_page.dart';
import 'pages/billing/billing_page.dart';
import 'pages/statistics/statistics_page.dart';
import 'pages/scanFacture/scanFacture_page.dart';
import 'pages/notification/notification_history_page.dart';
import 'pages/notification/notification_service.dart';
import 'pages/notification/rendezvous_notifier.dart';
import 'pages/patient/patient_controller.dart';
import 'pages/billing/billing_controller.dart';
import 'pages/appointment/appointment_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  tz.initializeTimeZones();
  await initializeDateFormatting('fr_FR', null); // ✅ pour DateFormat
  await NotificationService().init();
  Get.put(AppController());

  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => PatientController()..loadPatients(),
        ),
        ChangeNotifierProvider(
          create: (_) => BillingController()..loadFactures(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              AppointmentController()..loadAppointments(), // ✅ AJOUT ICI
        ),
        ChangeNotifierProvider(
            create: (_) => ProfileController()..initProfile())

        ChangeNotifierProvider(create: (_) => PatientController()..loadPatients()),
        ChangeNotifierProvider(create: (_) => BillingController()),
        ChangeNotifierProvider(create: (_) => AppointmentController()..loadAppointments()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final routes = {
    '/login': (context) => const LoginPage(),
    '/home': (context) => HomePage(),
    '/singup': (context) => SignupPage(),
    '/patient': (context) => PatientPage(),
    '/rendezVous': (context) => AppointmentPage(),
    '/facturation': (context) => BillingPage(),
    '/statistiques': (context) => StatisticsPage(),
    '/scanFacture': (context) => RecognitionPage(),
    '/parametre': (context) => Parametre()
    '/notifications': (context) => const NotificationHistoryPage(),
    '/splash': (context) => const SplashScreen(),
  };

  @override
  void initState() {
    super.initState();
    RendezvousNotifier().planifierTousLesRendezVous();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData dentalTheme = ThemeData(
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: const Color(0xFFF5F9FF),
      primaryColor: Colors.teal,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.tealAccent,
        primary: Colors.teal,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
        elevation: 0,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      cardTheme:  CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
        color: Colors.white,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
        labelSmall: TextStyle(fontSize: 12, color: Colors.grey),
      ),
      iconTheme: const IconThemeData(color: Colors.teal),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );

    return GetMaterialApp(
      translations: LocalString(),
      locale: Get.find<AppController>().locale.value, // ✅ corrigé ici
      fallbackLocale: const Locale('fr', 'FR'),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      theme: dentalTheme,
      darkTheme: ThemeData.dark(),
      themeMode:  Get.find<AppController>().themeMode.value,
      routes: routes,
    );
  }
}
