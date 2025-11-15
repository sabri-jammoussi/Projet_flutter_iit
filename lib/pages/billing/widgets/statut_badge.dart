import 'package:flutter/material.dart';
import 'package:dentiste/models/facture.dart';

class StatutBadge extends StatelessWidget {
  final StatutPaiement statut;

  const StatutBadge({required this.statut, super.key});

  Color get color {
    switch (statut) {
      case StatutPaiement.paye:
        return Colors.green.shade600;
      case StatutPaiement.partiel:
        return Colors.orange.shade600;
      case StatutPaiement.impaye:
        return Colors.red.shade600;
    }
  }

  String get label {
    switch (statut) {
      case StatutPaiement.paye:
        return 'Payée';
      case StatutPaiement.partiel:
        return 'Partielle';
      case StatutPaiement.impaye:
        return 'Impayée';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
