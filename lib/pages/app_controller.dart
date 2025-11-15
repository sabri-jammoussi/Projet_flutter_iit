import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  var themeMode = ThemeMode.system.obs;
  var locale = const Locale('fr', 'FR').obs;

  void toggleTheme() {
    themeMode.value =
        themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    Get.changeThemeMode(themeMode.value);
  }

  void changeLocale(Locale newLocale) {
    locale.value = newLocale;
    Get.updateLocale(newLocale);
  }
}
