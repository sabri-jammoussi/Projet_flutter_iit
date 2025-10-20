import 'package:flutter/material.dart';
import 'package:dentiste/models/facture.dart';

class StatutBadge extends StatelessWidget {
  final StatutPaiement statut;

  const StatutBadge({required this.statut, super.key});

  Color get color {
    switch (statut) {
      case StatutPaiement.paye:
        return Colors.green;
      case StatutPaiement.partiel:
        return Colors.orange;
      case StatutPaiement.impaye:
        return Colors.red;
    }
  }

  String get label => statut.name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
