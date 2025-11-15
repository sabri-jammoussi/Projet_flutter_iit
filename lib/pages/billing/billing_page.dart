import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dentiste/pages/billing/widgets/billing_card.dart';
import 'package:dentiste/pages/billing/widgets/billing_form.dart';
import 'package:dentiste/pages/billing/widgets/billing_summary.dart';
import 'package:dentiste/pages/billing/billing_controller.dart';

class BillingPage extends StatelessWidget {
  const BillingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facturation'),
        centerTitle: true,
      ),
      body: Consumer<BillingController>(
        builder: (context, controller, _) {
          final factures = controller.factures;

          if (factures.isEmpty) {
            return Center(
              child: Text(
                'Aucune facture enregistrée',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          return Column(
            children: [
               BillingSummary(),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: factures.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final facture = factures[index];
                    return BillingCard(
                      facture: facture,
                      onDelete: () => controller.removeFacture(facture),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => BillingForm(
              onSubmit: (newFacture) {
                Provider.of<BillingController>(context, listen: false)
                    .addFacture(newFacture);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Facture ajoutée avec succès'),
                    backgroundColor: Colors.green.shade600,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
