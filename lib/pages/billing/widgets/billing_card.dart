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
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.teal),
              title: Text(
                facture.patient.nom,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email : ${facture.patient.email}'),
                  Text('Âge : ${facture.patient.age} ans'),
                  const SizedBox(height: 4),
                  Text('Date : ${facture.date.toLocal().toString().split(' ')[0]}'),
                  Text('Mode de paiement : ${facture.modePaiement}'),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('Statut : '),
                      StatutBadge(statut: facture.statut),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Actes : ${facture.actes.map((a) => a.nom).join(', ')}'),
                  Text('Montant total : ${facture.montantTotal.toStringAsFixed(2)} TND'),
                  Text('Montant payé : ${facture.montantPaye.toStringAsFixed(2)} TND'),
                  Text('Reste à payer : ${facture.resteAPayer.toStringAsFixed(2)} TND'),
                ],
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
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
                  child: const Text('Modifier'),
                ),
                TextButton(
                  onPressed: onDelete,
                  child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
