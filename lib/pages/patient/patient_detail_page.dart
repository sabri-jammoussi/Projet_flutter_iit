import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dentiste/models/patient.dart';
import 'package:dentiste/pages/appointment/appointment_controller.dart';
import 'package:dentiste/pages/appointment/widgets/appointment_form.dart';
import 'package:dentiste/pages/appointment/widgets/appointment_title.dart';
import 'package:dentiste/pages/billing/billing_controller.dart';
import 'package:dentiste/pages/billing/widgets/billing_card.dart';
import 'package:dentiste/pages/billing/widgets/billing_form.dart';

class PatientDetailsPage extends StatelessWidget {
  final Patient patient;

  const PatientDetailsPage({required this.patient, super.key});

  @override
  Widget build(BuildContext context) {
    final factures = Provider.of<BillingController>(context).facturesPour(patient);
    final appointments = Provider.of<AppointmentController>(context).forPatient(patient);

    return Scaffold(
      appBar: AppBar(
        title: Text('Fiche de ${patient.nom}'),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/dentist.png'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(patient.nom,
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 4),
                          Text('Email : ${patient.email}',
                              style: Theme.of(context).textTheme.bodyMedium),
                          Text('Âge : ${patient.age} ans',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Historique de paiement',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            factures.isEmpty
                ? const Center(child: Text('Aucune facture pour ce patient.'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: factures.length,
                    itemBuilder: (context, index) {
                      return BillingCard(
                        facture: factures[index],
                        onDelete: () => Provider.of<BillingController>(context, listen: false)
                            .removeFacture(factures[index]),
                      );
                    },
                  ),
            const SizedBox(height: 24),
            Text('Rendez-vous',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            appointments.isEmpty
                ? const Center(child: Text('Aucun rendez-vous pour ce patient.'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      return AppointmentTile(appointment: appointments[index]);
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => Wrap(
              children: [
                _buildActionTile(
                  context,
                  icon: Icons.receipt,
                  label: 'Ajouter une facture',
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (_) => BillingForm(
                        onSubmit: (newFacture) {
                          Provider.of<BillingController>(context, listen: false)
                              .addFacture(newFacture);
                          Navigator.pop(context);
                        },
                        patient: patient,
                      ),
                    );
                  },
                ),
                _buildActionTile(
                  context,
                  icon: Icons.calendar_today,
                  label: 'Ajouter un rendez-vous',
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (_) => AppointmentForm(
                        onSubmit: (newAppointment) {
                          Provider.of<AppointmentController>(context, listen: false)
                              .addAppointment(newAppointment);
                          Navigator.pop(context);
                        },
                        patient: patient,
                      ),
                    );
                  },
                ),
                _buildActionTile(
                  context,
                  icon: Icons.flash_on,
                  label: 'Facturer automatiquement',
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (_) => BillingForm(
                        patient: patient,
                        onSubmit: (newFacture) {
                          Provider.of<BillingController>(context, listen: false)
                              .addFacture(newFacture);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Facture générée automatiquement')),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionTile(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(label),
      onTap: onTap,
    );
  }
}
