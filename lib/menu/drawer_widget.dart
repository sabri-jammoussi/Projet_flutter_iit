import 'package:dentiste/pages/parametre/parametre_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dentiste/config/global_params.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileController()..initProfile(),
      builder: (context, child) {
        final controller = context.watch<ProfileController>();

        // Show error message if any
        if (controller.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(controller.errorMessage!)),
            );
          });
        }

        return Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amberAccent, Colors.orange],
                  ),
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: controller.imageUrl != null
                        ? NetworkImage(controller.imageUrl!)
                            as ImageProvider<Object>
                        : const AssetImage('assets/images/dentist.jpg')
                            as ImageProvider<Object>,
                  ),
                ),
              ),
              ...GlobalParams.menus.map((item) {
                return ListTile(
                  title: Text(
                    (item['title'] as String).tr,
                    style: const TextStyle(fontSize: 22),
                  ),
                  leading: item['icon'] as Widget?,
                  trailing: const Icon(Icons.arrow_right, color: Colors.teal),
                  onTap: () {
                    Navigator.pop(context);
                    if ((item['title'] as String).tr != "Déconnexion") {
                      Navigator.pushNamed(context, item['route'] as String);
                    } else {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false);
                    }
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
