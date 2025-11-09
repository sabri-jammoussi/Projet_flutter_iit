import 'package:carousel_slider/carousel_slider.dart';
import 'package:dentiste/menu/drawer_widget.dart';
import 'package:dentiste/pages/scanFacture/scanFacture_page.dart';
import 'package:flutter/material.dart';
import 'package:dentiste/pages/home/home_controller.dart';
import 'package:dentiste/pages/home/widgets/dashboard_card.dart';
import 'package:dentiste/pages/home/widgets/quick_button.dart';
import 'package:dentiste/pages/patient/patient_page.dart';
import 'package:dentiste/pages/appointment/appointment_page.dart';
import 'package:dentiste/pages/billing/billing_page.dart';
import 'package:dentiste/pages/statistics/statistics_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomePage extends StatelessWidget {
  final controller = HomeController();

  HomePage({Key? key}) : super(key: key);
// for changing the the daarkmode
  toggleDarkMode() {
    if (Get.isDarkMode) {
      Get.changeTheme(ThemeData.light());
    } else {
      Get.changeTheme(ThemeData.dark());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        backgroundColor: Colors.teal,
                actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                // PopupMenuItem(
                //   child: ListTile(
                //     leading: Icon(Icons.map),
                //     title: Text('maps'.tr),
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) =>
                //               MapScreen(), // Replace MapsScreen with the actual screen you want to navigate to
                //         ),
                //       );
                //     },
                //   ),
                // ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Get.isDarkMode
                        ? Icons.brightness_7
                        : Icons.brightness_3),
                    title: Text('darkmode'.tr),
                    onTap: () {
                      toggleDarkMode();
                      Navigator.pop(context);
                    },
                  ),
                ),
                // PopupMenuItem(
                //   child: ListTile(
                //     leading: Icon(Icons.language),
                //     title: Text('Choisissez votre langue'.tr),
                //     onTap: () {
                //       buildLanguageDialog(context);
                //     },
                //   ),
                // ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bienvenue Dr. [Nom]',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const DashboardCard(
                icon: Icons.people,
                title: 'Patients',
                value: '128',
                color: Colors.blue),
            const DashboardCard(
                icon: Icons.calendar_today,
                title: 'Rendez-vous',
                value: '6',
                color: Colors.green),
            const DashboardCard(
                icon: Icons.attach_money,
                title: 'Revenus',
                value: '2,450 TND',
                color: Colors.orange),
            const DashboardCard(
                icon: Icons.bar_chart,
                title: 'Soins en cours',
                value: '14',
                color: Colors.purple),
            const SizedBox(height: 24),
            const Text('Accès rapide',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            CarouselSlider(
              options: CarouselOptions(
                height: 130,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                autoPlay: true,
                viewportFraction: 0.45,
              ),
              items: [
                QuickButton(
                    icon: Icons.people,
                    label: 'Patients',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PatientPage()));
                    }),
                QuickButton(
                    icon: Icons.calendar_today,
                    label: 'Rendez-vous',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AppointmentPage()));
                    }),
                QuickButton(
                    icon: Icons.receipt,
                    label: 'Facturation',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const BillingPage()));
                    }),
                QuickButton(
                    icon: Icons.bar_chart,
                    label: 'Statistiques',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const StatisticsPage()));
                    }),
                QuickButton(
                    icon: Icons.bar_chart,
                    label: 'ML_Kit',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RecognitionPage()));
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
