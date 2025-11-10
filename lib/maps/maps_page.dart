import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatelessWidget {
  List<String> languages = ["Français", "Anglais", "Arabe"];
  final List locales = [
    {'name': 'Anglais', 'locale': Locale('en', 'US')},
    {'name': 'Français', 'locale': Locale('fr', 'FR')},
    {'name': 'Arabe', 'locale': Locale('ar', 'TU')},
  ];
  void _changeLanguage(String language) {
    var selectedLocale = locales.firstWhere(
          (element) => element['name'] == language,
      orElse: () => null,
    );

    if (selectedLocale != null) {
      Get.updateLocale(selectedLocale['locale']);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('map'.tr),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(34.784376,10.733741),
          initialZoom: 17.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}