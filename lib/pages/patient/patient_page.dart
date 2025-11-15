import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dentiste/pages/patient/widgets/patient_card.dart';
import 'package:dentiste/pages/patient/widgets/patient_form.dart';
import 'package:dentiste/pages/patient/patient_controller.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({Key? key}) : super(key: key);

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PatientController>(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Liste des patients'),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).appBarTheme.foregroundColor,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Liste des patients',
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        centerTitle: true,

      ),

      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            // 🔍 Barre de recherche
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher un patient...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
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

                  return ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: patients.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
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
      ),

      // ➕ Bouton d’ajout
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
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
