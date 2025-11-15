import 'package:dentiste/pages/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final AppController appController = Get.find<AppController>();
  final MapController mapController = MapController();

  final List<Map<String, dynamic>> locales = [
    {'name': 'Français', 'locale': const Locale('fr', 'FR')},
    {'name': 'Anglais', 'locale': const Locale('en', 'US')},
    {'name': 'Arabe', 'locale': const Locale('ar', 'TU')},
  ];

  @override
  void initState() {
    super.initState();
    appController.fetchLocation(); // 🔄 Récupère la position GPS
  }

  void _changeLanguage(String language) {
    final selected = locales.firstWhere(
      (element) => element['name'] == language,
      orElse: () => {},
    );
    if (selected.isNotEmpty) {
      Get.updateLocale(selected['locale']);
    }
  }

  void _recenterMap() {
    final pos = appController.currentPosition.value;
    if (pos != null) {
      mapController.move(LatLng(pos.latitude, pos.longitude), 17.0);
    } else {
      Get.snackbar('Erreur', 'Position non disponible');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('map'.tr),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: 'Recentrer',
            onPressed: _recenterMap,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: _changeLanguage,
            itemBuilder: (context) => locales
                .map((e) => PopupMenuItem<String>(
                      value: e['name'],
                      child: Text(e['name']),
                    ))
                .toList(),
          ),
        ],
      ),
      body: Obx(() {
        final pos = appController.currentPosition.value;
        if (pos == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: LatLng(pos.latitude, pos.longitude),
            initialZoom: 17.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(pos.latitude, pos.longitude),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                ),
              ],
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(
                    Uri.parse('https://openstreetmap.org/copyright'),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
