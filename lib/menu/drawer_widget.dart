import 'package:dentiste/config/global_params.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
          ...(GlobalParams.menus as List).map((item) {
            return Column(
              children: [
                ListTile(
                  title: Text(
                    '${item['title']}',
                    style: TextStyle(fontSize: 22),
                  ),
                  leading: item['icon'],
                  trailing: Icon(Icons.arrow_right, color: Colors.teal),
                  onTap: () async {
                    if ('${item['title']}' != "Déconnexion") {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "${item['route']}");
                    } else {
                      /*prefs = await SharedPreferences.getInstance();
                      prefs.setBool("connecte", false);*/
                      // FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false);

                      //Navigator.pushAndRemoveUntil(context,'/authentification', (route) => false);
                    }
                  },
                )
              ],
            );
          }),
        ],
      ),
    );
  }
}
