import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StatSummary extends StatelessWidget {
  final DateTime selectedMonth;
  const StatSummary({super.key, required this.selectedMonth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatCard(
          context,
          icon: Icons.people,
          label: 'Patients',
          stream: FirebaseFirestore.instance.collection('patients').snapshots(),
          formatter: (snapshot) => '${snapshot.size}',
        ),
        const SizedBox(height: 0),
        _buildStatCard(
          context,
          icon: Icons.event,
          label: 'Rendez-vous (ce mois)',
          stream: FirebaseFirestore.instance
              .collection('appointments')
              .where('dateTime', isGreaterThanOrEqualTo: _startOfMonth())
              .where('dateTime', isLessThan: _endOfMonth())
              .snapshots(),
          formatter: (snapshot) => '${snapshot.size}',
        ),
        const SizedBox(height: 0),
        _buildStatCard(
          context,
          icon: Icons.receipt_long,
          label: 'Factures (ce mois)',
          stream: FirebaseFirestore.instance
              .collection('factures')
              .where('dateTime', isGreaterThanOrEqualTo: _startOfMonth())
              .where('dateTime', isLessThan: _endOfMonth())
              .snapshots(),
          formatter: (snapshot) => '${snapshot.size}',
        ),
        const SizedBox(height: 0),
        _buildStatCard(
          context,
          icon: Icons.attach_money,
          label: 'Revenu (ce mois)',
          stream: FirebaseFirestore.instance
              .collection('factures')
              .where('dateTime', isGreaterThanOrEqualTo: _startOfMonth())
              .where('dateTime', isLessThan: _endOfMonth())
              .snapshots(),
          formatter: (snapshot) {
            double total = 0.0;
            for (var doc in snapshot.docs) {
              final montant = doc['montantPaye'];
              if (montant is num) {
                total += montant.toDouble();
              } else if (montant is String) {
                total += double.tryParse(montant) ?? 0.0;
              }
            }
            return '${total.toStringAsFixed(2)} TND';
          },
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Stream<QuerySnapshot> stream,
    required String Function(QuerySnapshot) formatter,
  }) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        final value = snapshot.hasData ? formatter(snapshot.data!) : '...';
        return Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(icon, color: Theme.of(context).primaryColor),
            ),
            title: Text(label, style: Theme.of(context).textTheme.bodyMedium),
            trailing: Text(value,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  Timestamp _startOfMonth() =>
      Timestamp.fromDate(DateTime(selectedMonth.year, selectedMonth.month));
  Timestamp _endOfMonth() =>
      Timestamp.fromDate(DateTime(selectedMonth.year, selectedMonth.month + 1));
}
