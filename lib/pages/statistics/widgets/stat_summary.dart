import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StatSummary extends StatelessWidget {
  final DateTime selectedMonth;
  const StatSummary({super.key, required this.selectedMonth});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatTile('👥 Patients', FirebaseFirestore.instance.collection('patients')),
        _buildMonthlyStatTile('📅 Rendez-vous', FirebaseFirestore.instance.collection('appointments')),
        _buildMonthlyStatTile('💳 Factures', FirebaseFirestore.instance.collection('factures')),
        _buildMonthlyRevenueTile(),
      ],
    );
  }

  Widget _buildStatTile(String label, CollectionReference collection) {
    return StreamBuilder<QuerySnapshot>(
      stream: collection.snapshots(),
      builder: (context, snapshot) {
        final count = snapshot.data?.size ?? 0;
        return Text('$label : $count', style: const TextStyle(fontSize: 16));
      },
    );
  }

  Widget _buildMonthlyStatTile(String label, CollectionReference collection) {
    final start = Timestamp.fromDate(DateTime(selectedMonth.year, selectedMonth.month));
    final end = Timestamp.fromDate(DateTime(selectedMonth.year, selectedMonth.month + 1));

    return StreamBuilder<QuerySnapshot>(
      stream: collection
          .where('dateTime', isGreaterThanOrEqualTo: start)
          .where('dateTime', isLessThan: end)
          .snapshots(),
      builder: (context, snapshot) {
        final count = snapshot.data?.size ?? 0;
        return Text('$label (ce mois) : $count', style: const TextStyle(fontSize: 16));
      },
    );
  }

  Widget _buildMonthlyRevenueTile() {
    final start = Timestamp.fromDate(DateTime(selectedMonth.year, selectedMonth.month));
    final end = Timestamp.fromDate(DateTime(selectedMonth.year, selectedMonth.month + 1));

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('factures')
          .where('dateTime', isGreaterThanOrEqualTo: start)
          .where('dateTime', isLessThan: end)
          .snapshots(),
      builder: (context, snapshot) {
        double total = 0.0;
        if (snapshot.hasData) {
          for (var doc in snapshot.data!.docs) {
            final montant = doc['montantPaye'];
            if (montant is num) {
              total += montant.toDouble();
            }
          }
        }
        return Text('💰 Revenu (ce mois) : ${total.toStringAsFixed(2)} TND',
            style: const TextStyle(fontSize: 16));
      },
    );
  }
}
