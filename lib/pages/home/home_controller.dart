import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:dentiste/pages/authentification/login_page.dart';

class HomeController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Déconnecte l'utilisateur, vide les préférences locales et redirige vers la page de connexion
  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut(); // Déconnexion Firebase
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Nettoyage local

      // Redirection
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Échec de la déconnexion : ${e.toString()}',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Retourne l'utilisateur actuellement connecté
  User? get currentUser => _auth.currentUser;

  /// Retourne l'email de l'utilisateur ou une chaîne vide
  String get userEmail => currentUser?.email ?? '';
}
