import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StatisticsController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<int> get totalPatientsStream =>
      _db.collection('patients').snapshots().map((snap) => snap.size);

  Stream<int> get totalAppointmentsStream =>
      _db.collection('appointments').snapshots().map((snap) => snap.size);

  Stream<int> get totalFacturesStream =>
      _db.collection('factures').snapshots().map((snap) => snap.size);

  Stream<double> get totalRevenueStream => _db
      .collection('factures')
      .snapshots()
      .map((snap) => snap.docs.fold(0.0, (sum, doc) {
            final montant = doc['montantPaye'];
            return sum + (montant is num ? montant.toDouble() : 0.0);
          }));

  Stream<Map<String, int>> get appointmentStatusStream => _db
      .collection('appointments')
      .snapshots()
      .map((snap) {
        final Map<String, int> statusCount = {};
        for (var doc in snap.docs) {
          final status = doc['status'] ?? 'pending';
          statusCount[status] = (statusCount[status] ?? 0) + 1;
        }
        return statusCount;
      });
}
