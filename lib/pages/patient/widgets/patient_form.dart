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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Theme.of(context).cardTheme.color,
      title: Text('Ajouter un patient',
          style: Theme.of(context).textTheme.titleLarge),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildField(
                context,
                label: 'Nom',
                icon: Icons.person,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Champ requis' : null,
                onSaved: (value) => nom = value ?? '',
              ),
              const SizedBox(height: 12),
              _buildField(
                context,
                label: 'Âge',
                icon: Icons.cake,
                keyboardType: TextInputType.number,
                validator: (value) {
                  final parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed <= 0) return 'Âge invalide';
                  return null;
                },
                onSaved: (value) => age = int.tryParse(value ?? '') ?? 0,
              ),
              const SizedBox(height: 12),
              _buildField(
                context,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value != null && value.contains('@') ? null : 'Email invalide',
                onSaved: (value) => email = value ?? '',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
              widget.onSubmit(Patient(nom: nom, age: age, email: email));
              Navigator.pop(context);
            }
          },
          child: Text('Ajouter', style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ],
    );
  }

  Widget _buildField(
    BuildContext context, {
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).iconTheme.color),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
