import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dentiste/models/appointment.dart';
import 'package:dentiste/models/patient.dart';
import 'package:dentiste/pages/patient/patient_controller.dart';

class AppointmentForm extends StatefulWidget {
  final void Function(Appointment) onSubmit;
  final Patient? patient;

  const AppointmentForm({required this.onSubmit, this.patient, super.key});

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final _formKey = GlobalKey<FormState>();
  Patient? selectedPatient;
  DateTime selectedDateTime = DateTime.now();
  String reason = '';
  AppointmentStatus selectedStatus = AppointmentStatus.pending;

  @override
  void initState() {
    super.initState();
    selectedPatient = widget.patient;
  }

  String _statusLabel(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.confirmed:
        return 'Confirmé';
      case AppointmentStatus.cancelled:
        return 'Annulé';
      case AppointmentStatus.completed:
        return 'Terminé';
      case AppointmentStatus.pending:
        return 'En attente';
    }
  }

  @override
  Widget build(BuildContext context) {
    final patients = Provider.of<PatientController>(context).patients;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Theme.of(context).cardColor,
      title: Text(
        'Nouveau rendez-vous',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Patient>(
                decoration: _inputDecoration(context, 'Patient'),
                value: selectedPatient,
                items: patients
                    .map((p) => DropdownMenuItem(value: p, child: Text(p.nom)))
                    .toList(),
                onChanged: widget.patient == null
                    ? (value) => setState(() => selectedPatient = value)
                    : null,
                validator: (value) =>
                    value == null ? 'Veuillez sélectionner un patient' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: _inputDecoration(context, 'Motif'),
                onSaved: (value) => reason = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<AppointmentStatus>(
                decoration: _inputDecoration(context, 'Statut'),
                value: selectedStatus,
                items: AppointmentStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(_statusLabel(status)),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedStatus = value!),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDateTime,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
                label: Text(
                  'Date : ${selectedDateTime.day.toString().padLeft(2, '0')}/'
                  '${selectedDateTime.month.toString().padLeft(2, '0')}/'
                  '${selectedDateTime.year} '
                  '${selectedDateTime.hour.toString().padLeft(2, '0')}:'
                  '${selectedDateTime.minute.toString().padLeft(2, '0')}',
                ),
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
              widget.onSubmit(Appointment(
                patient: selectedPatient!,
                dateTime: selectedDateTime,
                status: selectedStatus,
                
              ));
              Navigator.pop(context);
            }
          },
          child: Text('Ajouter', style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
