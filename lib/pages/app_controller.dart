import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart'; // ✅ Import nécessaire pour LatLng

class AppController extends GetxController {
  /// 🎨 Mode thème clair/sombre
  var themeMode = ThemeMode.system.obs;

  /// 🌍 Langue actuelle
  var locale = const Locale('fr', 'FR').obs;

  /// 📍 Position GPS actuelle
  var currentPosition = Rxn<Position>();

  /// 🔁 Stream de position en temps réel (optionnel)
  Stream<Position>? positionStream;

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

  /// 📍 Récupérer la position GPS une fois
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

  /// 🔁 Suivre la position en temps réel (optionnel)
  void startTrackingLocation() {
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );

    positionStream!.listen((Position position) {
      currentPosition.value = position;
    });
  }

  /// 📍 Getter pratique pour récupérer LatLng
  LatLng? get currentLatLng {
    final pos = currentPosition.value;
    if (pos == null) return null;
    return LatLng(pos.latitude, pos.longitude);
  }
}
