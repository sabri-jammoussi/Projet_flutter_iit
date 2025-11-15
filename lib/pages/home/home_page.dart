import 'package:dentiste/pages/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

import '../../translations/LocaleString.dart';
import '../../menu/drawer_widget.dart';
import '../../pages/patient/patient_page.dart';
import '../../pages/appointment/appointment_page.dart';
import '../../pages/billing/billing_page.dart';
import '../../pages/statistics/statistics_page.dart';
import '../../pages/scanFacture/scanFacture_page.dart';
import '../../pages/notification/notification_history_page.dart';

class HomePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        title: Text('dashboard'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
         PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      onSelected: (value) {
        final controller = Get.find<AppController>();
        if (value == 'fr') controller.changeLocale(const Locale('fr', 'FR'));
        if (value == 'en') controller.changeLocale(const Locale('en', 'US'));
        if (value == 'ar') controller.changeLocale(const Locale('ar', 'AR'));
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'fr', child: Text('Français')),
        const PopupMenuItem(value: 'en', child: Text('English')),
        const PopupMenuItem(value: 'ar', child: Text('العربية')),
      ],
    ),
           IconButton(
      icon: const Icon(Icons.brightness_6),
      onPressed: () => Get.find<AppController>().toggleTheme(),
    ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationHistoryPage()));
            },
          ),
           IconButton(
      icon: const Icon(Icons.location_on),
      onPressed: () {
        // Ajoute ici ta logique de localisation
        Get.snackbar('location'.tr, 'Fonction de localisation à implémenter');
  },),],
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/dentist.png'),
                  radius: 24,
                ),
                title: Text('welcome_doctor'.tr,
                    style: Theme.of(context).textTheme.titleLarge),
                subtitle: Text(user?.email ?? '',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildStatCard(context, Icons.people, 'patients'.tr, '128', Colors.blue),
                _buildStatCard(context, Icons.calendar_today, 'appointments'.tr, '6', Colors.green),
                _buildStatCard(context, Icons.attach_money, 'Revenus', '2,450 TND', Colors.orange),
                _buildStatCard(context, Icons.healing, 'Soins en cours', '14', Colors.purple),
              ],
            ),
            const SizedBox(height: 24),
            Text('quick_access'.tr,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            CarouselSlider(
              options: CarouselOptions(
                height: 120,
                enlargeCenterPage: true,
                autoPlay: true,
                viewportFraction: 0.45,
              ),
              items: [
                _buildQuickButton(context, Icons.people, 'patients'.tr, const PatientPage()),
                _buildQuickButton(context, Icons.calendar_today, 'appointments'.tr, const AppointmentPage()),
                _buildQuickButton(context, Icons.receipt, 'billing'.tr, const BillingPage()),
                _buildQuickButton(context, Icons.bar_chart, 'statistics'.tr, StatisticsPage()),
                _buildQuickButton(context, Icons.scanner, 'ML_Kit', const RecognitionPage()),
                _buildQuickButton(context, Icons.notifications, 'notification'.tr, const NotificationHistoryPage()),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          // Navigation logic ici si besoin
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Patients'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'RDV'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Factures'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, IconData icon, String title, String value, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickButton(BuildContext context, IconData icon, String label, Widget page) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
