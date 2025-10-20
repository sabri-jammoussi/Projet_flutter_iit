import 'package:flutter/material.dart';
import 'package:dentiste/models/patient.dart';

class PatientForm extends StatefulWidget {
  final void Function(Patient) onSubmit;

  const PatientForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<PatientForm> createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final _formKey = GlobalKey<FormState>();
  String nom = '';
  int age = 0;
  String email = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un patient'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nom'),
              onSaved: (value) => nom = value ?? '',
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Âge'),
              keyboardType: TextInputType.number,
              onSaved: (value) => age = int.tryParse(value ?? '') ?? 0,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              onSaved: (value) => email = value ?? '',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _formKey.currentState?.save();
            widget.onSubmit(Patient(nom: nom, age: age, email: email));
            Navigator.pop(context);
          },
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}
