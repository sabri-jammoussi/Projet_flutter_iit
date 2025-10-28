import 'package:dentiste/firebase_options.dart';
import 'package:dentiste/pages/appointment/appointment_controller.dart';
import 'package:flutter/material.dart';
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
            create: (_) => PatientController()..loadPatients()),
        ChangeNotifierProvider(
            create: (_) => BillingController()..loadFactures()),
        ChangeNotifierProvider(create: (_) => AppointmentController()),
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
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: routes,
    );
  }
}
