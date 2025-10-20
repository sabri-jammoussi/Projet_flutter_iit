import 'package:dentiste/pages/billing/billing_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillingSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BillingController>(context);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Résumé des paiements', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Total facturé : ${controller.totalFactures.toStringAsFixed(2)} TND'),
            Text('Payé : ${controller.totalPaye.toStringAsFixed(2)} TND'),
            Text('Partiel : ${controller.totalPartiel.toStringAsFixed(2)} TND'),
            Text('Impayé : ${controller.totalImpaye.toStringAsFixed(2)} TND'),
          ],
        ),
      ),
    );
  }
}
