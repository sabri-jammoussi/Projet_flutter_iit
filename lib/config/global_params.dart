import 'package:flutter/material.dart';

class GlobalParams {
  static List<Map<String, dynamic>> menus = [
    {
      "title": "dashboard",
      "icon": Icon(
        Icons.home,
        color: Colors.teal,
      ),
      "route": "/home"
    },
    {
      "title": "patients",
      "icon": Icon(
        Icons.people,
        color: Colors.teal,
      ),
      "route": "/patient"
    },
    {
      "title": "appointments",
      "icon": Icon(
        Icons.calendar_today,
        color: Colors.teal,
      ),
      "route": "/rendezVous"
    },
    {
      "title": "billing",
      "icon": Icon(
        Icons.receipt,
        color: Colors.teal,
      ),
      "route": "/facturation"
    },
    {
      "title": "statistics",
      "icon": Icon(
        Icons.bar_chart,
        color: Colors.teal,
      ),
      "route": "/statistiques"
    },
    {
      "title": "Notification",
      "icon": Icon(
        Icons.notifications,
        color: Colors.teal,
      ),
      "route": "/notifications"
    },
    {
      "title": "mlkit",
      "icon": Icon(
        Icons.contact_page,
        color: Colors.teal,
      ),
      "route": "/scanFacture"
    },
    {
      "title": "settings",
      "icon": Icon(
        Icons.settings,
        color: Colors.teal,
      ),
      "route": "/parametre"
    },
    {
      "title": "logout",
      "icon": Icon(
        Icons.logout,
        color: Colors.teal,
      ),
      "route": "/login"
    },
  ];
}
