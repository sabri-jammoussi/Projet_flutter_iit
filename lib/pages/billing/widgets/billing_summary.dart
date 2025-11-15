import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dentiste/pages/billing/billing_controller.dart';

class BillingSummary extends StatelessWidget {
  const BillingSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BillingController>(context);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Résumé des paiements',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildLine(context, 'Total facturé', controller.totalFactures),
            _buildLine(context, 'Payé', controller.totalPaye, color: Colors.green),
            _buildLine(context, 'Partiel', controller.totalPartiel, color: Colors.orange),
            _buildLine(context, 'Impayé', controller.totalImpaye, color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildLine(BuildContext context, String label, double amount, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(
            '${amount.toStringAsFixed(2)} TND',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
