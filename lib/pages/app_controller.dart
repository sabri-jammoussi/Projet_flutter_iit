import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class AppController extends GetxController {
  var themeMode = ThemeMode.system.obs;
  var locale = const Locale('fr', 'FR').obs;
  var currentPosition = Rxn<Position>();

  /// 🌙 Bascule entre clair et sombre
  void toggleTheme() {
    themeMode.value =
        themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    Get.changeThemeMode(themeMode.value);
  }

  /// 🌍 Changer la langue
  void changeLocale(Locale newLocale) {
    locale.value = newLocale;
    Get.updateLocale(newLocale);
  }

  /// 📍 Récupérer la position GPS
  Future<void> fetchLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Erreur', 'Service de localisation désactivé');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Erreur', 'Permission refusée');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Erreur', 'Permission refusée définitivement');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentPosition.value = position;
      Get.snackbar(
        'Position actuelle',
        'Lat: ${position.latitude}, Long: ${position.longitude}',
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de récupérer la position');
    }
  }
}
