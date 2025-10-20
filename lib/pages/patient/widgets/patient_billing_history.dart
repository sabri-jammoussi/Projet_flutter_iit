import 'package:dentiste/models/patient.dart';
import 'package:dentiste/pages/billing/billing_controller.dart';
import 'package:dentiste/pages/billing/widgets/billing_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientBillingHistory extends StatelessWidget {
  final Patient patient;

  const PatientBillingHistory({required this.patient, super.key});

  @override
  Widget build(BuildContext context) {
    final factures = Provider.of<BillingController>(context)
        .facturesPour(patient);

    if (factures.isEmpty) {
      return const Text('Aucune facture pour ce patient.');
    }

    return Column(
      children: factures.map((f) => BillingCard(facture: f, onDelete: () {})).toList(),
    );
  }
}
