// lib/pages/patient/widgets/patient_card.dart
import 'package:flutter/material.dart';
import 'package:dentiste/models/patient.dart';
import 'package:dentiste/pages/patient/patient_detail_page.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;
  final VoidCallback onDelete;

  const PatientCard({
    Key? key,
    required this.patient,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.person, color: Colors.teal),
        title: Text(patient.nom),
        subtitle: Text('Âge: ${patient.age} • ${patient.email}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PatientDetailsPage(patient: patient),
            ),
          );
        },
      ),
    );
  }
}
