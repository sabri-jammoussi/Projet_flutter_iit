import 'package:dentiste/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'pages/authentification/loginPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final routes = {
    '/login': (context) => LoginPage(),
    '/home': (context) => HomePage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // optional: set the starting page
      routes: routes,
    );
  }
}
