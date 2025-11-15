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
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:dentiste/pages/authentification/login_page.dart';
import 'package:dentiste/pages/home/home_page.dart';
import 'package:dentiste/pages/patient/patient_controller.dart';
import 'package:dentiste/pages/billing/billing_controller.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
  final List locale = [
    {'name': 'FRANCE', 'locale': Locale('en', 'FR')},
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'اللغة العربية', 'locale': Locale('en', 'AR')},
  ];
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
  };

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   initialRoute: '/login',
    //   routes: routes,
    // );
    return GetMaterialApp(
      translations: LocalString(),
      locale: Locale('en', 'FR'),
      fallbackLocale: Locale('en', 'FR'),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      routes: routes,
    );
  }
}
