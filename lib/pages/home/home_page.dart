import 'package:carousel_slider/carousel_slider.dart';
import 'package:dentiste/config/global_params.dart';
import 'package:dentiste/maps/maps_page.dart';
import 'package:dentiste/menu/drawer_widget.dart';
import 'package:dentiste/pages/scanFacture/scanFacture_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import '../../translations/LocaleString.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();

  int _currentIndex = 0;
  final user = FirebaseAuth.instance.currentUser;

// for changing the the daarkmode
  toggleDarkMode() {
    if (Get.isDarkMode) {
      Get.changeTheme(ThemeData.light());
    } else {
      Get.changeTheme(ThemeData.dark());
    }
  }

  final List<Widget> pages = [
    HomePage(),
    PatientPage(),
    AppointmentPage(),
    BillingPage(),
    StatisticsPage(),
    RecognitionPage(),
  ];
  final List locale = [
    {'name': 'FRANÇAIS', 'locale': Locale('en', 'FR')},
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'العربية', 'locale': Locale('en', 'AR')},
  ];

  updateLanguage(Locale locale) {
    Get.updateLocale(locale);
    Get.back();
  }

  buildLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          title: Text('Choisissez votre langue'.tr),
          content: Container(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Text(locale[index]['name']),
                    onTap: () {
                      print(locale[index]['name']);
                      updateLanguage(locale[index]['locale']);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.blue,
                );
              },
              itemCount: locale.length,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('dashboard'.tr),
        backgroundColor: Colors.teal,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.map),
                    title: Text('maps'.tr),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MapScreen(), // Replace MapsScreen with the actual screen you want to navigate to
                        ),
                      );
                    },
                  ),
                ),
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
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.language),
                    title: Text('choose_language'.tr),
                    onTap: () {
                      buildLanguageDialog(context);
                    },
                  ),
                ),
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
            Text('${'welcome_doctor'.tr} [${user?.email}]',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DashboardCard(
                icon: Icons.people,
                title: 'patients'.tr,
                value: '128',
                color: Colors.blue),
            DashboardCard(
                icon: Icons.calendar_today,
                title: 'appointments'.tr,
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
            Text('quick_access'.tr,
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
                    label: 'patients'.tr,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PatientPage()));
                    }),
                QuickButton(
                    icon: Icons.calendar_today,
                    label: 'appointments'.tr,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AppointmentPage()));
                    }),
                QuickButton(
                    icon: Icons.receipt,
                    label: 'billing'.tr,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const BillingPage()));
                    }),
                QuickButton(
                    icon: Icons.bar_chart,
                    label: 'statistics'.tr,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => StatisticsPage()));
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          final route = GlobalParams.menus[index]["route"];
          if (route != "/home") {
            Navigator.pushNamed(context, route);
          }
        },
        items: GlobalParams.menus
            .take(6)
            .map(
              (menu) => BottomNavigationBarItem(
                icon: menu["icon"],
                label: (menu["title"] as String).tr,
              ),
            )
            .toList(),
      ),
    );
  }
}
