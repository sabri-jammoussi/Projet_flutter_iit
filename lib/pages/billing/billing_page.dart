import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dentiste/pages/billing/widgets/billing_card.dart';
import 'package:dentiste/pages/billing/widgets/billing_form.dart';
import 'package:dentiste/pages/billing/billing_controller.dart';

class BillingPage extends StatelessWidget {
  const BillingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facturation'),
        backgroundColor: Colors.teal,
      ),
      body: Consumer<BillingController>(
        builder: (context, controller, _) {
          final factures = controller.factures;

          if (factures.isEmpty) {
            return const Center(
              child: Text('Aucune facture enregistrée'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: factures.length,
            itemBuilder: (context, index) {
              final facture = factures[index];
              return BillingCard(
                facture: facture,
                onDelete: () => controller.removeFacture(facture),
              );
            },
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (scaffoldContext) => FloatingActionButton(
          backgroundColor: Colors.teal,
          onPressed: () {
            showDialog(
              context: scaffoldContext,
              builder: (_) => BillingForm(
                onSubmit: (newFacture) {
                  Provider.of<BillingController>(scaffoldContext, listen: false)
                      .addFacture(newFacture);

                  Navigator.pop(scaffoldContext);

                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    const SnackBar(
                      content: Text('Facture ajoutée avec succès'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
