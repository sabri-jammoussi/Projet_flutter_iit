import 'package:dentiste/pages/scanFacture/scanFacture_page.dart';
import 'package:flutter/material.dart';
import 'package:dentiste/pages/home/home_controller.dart';
import 'package:dentiste/pages/home/widgets/dashboard_card.dart';
import 'package:dentiste/pages/home/widgets/quick_button.dart';
import 'package:dentiste/pages/patient/patient_page.dart';
import 'package:dentiste/pages/appointment/appointment_page.dart';
import 'package:dentiste/pages/billing/billing_page.dart';
import 'package:dentiste/pages/statistics/statistics_page.dart';

class HomePage extends StatelessWidget {
  final controller = HomeController();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [Colors.amberAccent, Colors.orange]),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/dentist.jpg'),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () => controller.logout(context),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        backgroundColor: Colors.teal,
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
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
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
