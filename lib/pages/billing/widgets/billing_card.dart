import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dentiste/models/facture.dart';
import 'package:dentiste/pages/billing/widgets/billing_form.dart';
import 'package:dentiste/pages/billing/widgets/statut_badge.dart';
import 'package:dentiste/pages/billing/billing_controller.dart';

class BillingCard extends StatelessWidget {
  final Facture facture;
  final VoidCallback onDelete;

  const BillingCard({required this.facture, required this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: const Icon(Icons.receipt_long, color: Colors.teal),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    facture.patient.nom,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                StatutBadge(statut: facture.statutEnum),
              ],
            ),
            const SizedBox(height: 8),
            Text('Email : ${facture.patient.email}', style: Theme.of(context).textTheme.bodyMedium),
            Text('Âge : ${facture.patient.age} ans', style: Theme.of(context).textTheme.bodyMedium),
            Text('Date : ${facture.date.toLocal().toString().split(' ')[0]}', style: Theme.of(context).textTheme.bodyMedium),
            Text('Mode de paiement : ${facture.modePaiement}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Actes : ${facture.actes.map((a) => a.nom).join(', ')}', style: Theme.of(context).textTheme.bodyMedium),
            Text('Montant total : ${facture.montantTotal.toStringAsFixed(2)} TND', style: Theme.of(context).textTheme.bodyMedium),
            Text('Montant payé : ${facture.montantPaye.toStringAsFixed(2)} TND', style: Theme.of(context).textTheme.bodyMedium),
            Text('Reste à payer : ${facture.resteAPayer.toStringAsFixed(2)} TND', style: Theme.of(context).textTheme.bodyMedium),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Modifier'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => BillingForm(
                        facture: facture,
                        onSubmit: (updatedFacture) {
                          Provider.of<BillingController>(context, listen: false)
                              .updateFacture(facture, updatedFacture);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.delete, size: 18, color: Colors.redAccent),
                  label: const Text('Supprimer', style: TextStyle(color: Colors.redAccent)),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
