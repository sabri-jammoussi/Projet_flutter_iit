import 'package:dentiste/pages/appointment/widgets/appointment_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dentiste/models/patient.dart';
import 'package:dentiste/pages/billing/billing_controller.dart';
import 'package:dentiste/pages/billing/widgets/billing_card.dart';
import 'package:dentiste/pages/billing/widgets/billing_form.dart';
import 'package:dentiste/pages/appointment/appointment_controller.dart';
import 'package:dentiste/pages/appointment/widgets/appointment_form.dart';

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
        backgroundColor: Colors.teal,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Infos du patient
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nom : ${patient.nom}', style: Theme.of(context).textTheme.titleLarge),
                Text('Email : ${patient.email}'),
                Text('Âge : ${patient.age} ans'),
              ],
            ),
          ),

          const Divider(),

          // Historique de paiement
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Historique de paiement',
                style: Theme.of(context).textTheme.titleMedium),
          ),
          SizedBox(
            height: 200,
            child: factures.isEmpty
                ? const Center(child: Text('Aucune facture pour ce patient.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: factures.length,
                    itemBuilder: (context, index) {
                      return BillingCard(
                        facture: factures[index],
                        onDelete: () => Provider.of<BillingController>(context, listen: false)
                            .removeFacture(factures[index]),
                      );
                    },
                  ),
          ),

          const Divider(),

          // Appointments
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Appointments',
                style: Theme.of(context).textTheme.titleMedium),
          ),
          SizedBox(
            height: 200,
            child: appointments.isEmpty
                ? const Center(child: Text('No appointments for this patient.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      return AppointmentTile(appointment: appointments[index]);
                    },
                  ),
          ),
        ],
      ),

      // Bouton flottant avec menu
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.receipt),
                  title: const Text('Ajouter une facture'),
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
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Ajouter un appointment'),
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
              ],
            ),
          );
        },
      ),
    );
  }
}
