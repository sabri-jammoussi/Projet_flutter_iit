import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dentiste/models/patient.dart';
import 'package:dentiste/pages/billing/billing_controller.dart';
import 'package:dentiste/pages/billing/widgets/billing_card.dart';

class PatientBillingHistory extends StatelessWidget {
  final Patient patient;

  const PatientBillingHistory({required this.patient, super.key});

  @override
  Widget build(BuildContext context) {
    final factures = Provider.of<BillingController>(context).facturesPour(patient);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Historique de paiement',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        factures.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text('Aucune facture pour ce patient.',
                    style: Theme.of(context).textTheme.bodyMedium),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: factures.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final facture = factures[index];
                  return BillingCard(
                    facture: facture,
                    onDelete: () {
                      Provider.of<BillingController>(context, listen: false)
                          .removeFacture(facture);
                    },
                  );
                },
              ),
      ],
    );
  }
}
