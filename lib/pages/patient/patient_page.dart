import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dentiste/pages/patient/widgets/patient_card.dart';
import 'package:dentiste/pages/patient/widgets/patient_form.dart';
import 'package:dentiste/pages/patient/patient_controller.dart';

class PatientPage extends StatelessWidget {
  const PatientPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PatientController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des patients'),
        leading: IconButton(
         icon: const Icon(Icons.arrow_back),
         onPressed: () => Navigator.pop(context),
  ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // 🔍 Barre de recherche
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un patient...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: controller.search,
            ),
          ),

          // 📋 Liste des patients filtrés
          Expanded(
            child: Consumer<PatientController>(
              builder: (context, controller, _) {
                final patients = controller.patients;

                if (patients.isEmpty) {
                  return const Center(
                    child: Text('Aucun patient trouvé'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    final patient = patients[index];
                    return PatientCard(
                      patient: patient,
                      onDelete: () => controller.removePatient(patient),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // ➕ Bouton d’ajout
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => PatientForm(
              onSubmit: (newPatient) {
                Provider.of<PatientController>(context, listen: false)
                    .addPatient(newPatient);
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
