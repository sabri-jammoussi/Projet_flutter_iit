import 'package:flutter/material.dart';

class GlobalParams {
  static List<Map<String, dynamic>> menus = [
    {
      "title": "Accueil",
      "icon": Icon(
        Icons.home,
        color: Colors.teal,
      ),
      "route": "/home"
    },
    {
      "title": "Patients",
      "icon": Icon(
        Icons.people,
        color: Colors.teal,
      ),
      "route": "/patient"
    },
    {
      "title": "Rendez-vous",
      "icon": Icon(
        Icons.calendar_today,
        color: Colors.teal,
      ),
      "route": "/rendezVous"
    },
    {
      "title": "Facturation",
      "icon": Icon(
        Icons.receipt,
        color: Colors.teal,
      ),
      "route": "/facturation"
    },
    {
      "title": "Statistiques",
      "icon": Icon(
        Icons.bar_chart,
        color: Colors.teal,
      ),
      "route": "/statistiques"
    },
    {
      "title": "ML_kit",
      "icon": Icon(
        Icons.contact_page,
        color: Colors.teal,
      ),
      "route": "/scanFacture"
    },
    {
      "title": "Paramètres",
      "icon": Icon(
        Icons.settings,
        color: Colors.teal,
      ),
      "route": "/parametres"
    },
    {
      "title": "Déconnexion",
      "icon": Icon(
        Icons.logout,
        color: Colors.teal,
      ),
      "route": "/login"
    },
  ];
}
