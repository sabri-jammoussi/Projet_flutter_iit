import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed('/login'); // Redirection vers la page de login
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_hospital, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              'DentalCare',
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Votre santé bucco-dentaire, notre priorité',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3.5,
            ),
          ],
        ),
      ),
    );
  }
}
