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
  void initState() {
    super.initState();
    selectedPatient = widget.patient;
  }

  @override
  Widget build(BuildContext context) {
    final patients = Provider.of<PatientController>(context).patients;

    return AlertDialog(
      title: const Text('New Appointment'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Patient>(
                decoration: const InputDecoration(labelText: 'Patient'),
                value: selectedPatient,
                items: patients.map((p) => DropdownMenuItem(value: p, child: Text(p.nom))).toList(),
                onChanged: widget.patient == null
                    ? (value) => setState(() => selectedPatient = value)
                    : null,
                validator: (value) => value == null ? 'Select a patient' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Reason'),
                onSaved: (value) => reason = value ?? '',
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              DropdownButtonFormField<AppointmentStatus>(
  decoration: const InputDecoration(labelText: 'Statut'),
  value: selectedStatus,
  items: AppointmentStatus.values.map((status) {
    return DropdownMenuItem(
      value: status,
      child: Text(_statusLabel(status)),
    );
  }).toList(),
  onChanged: (value) => setState(() => selectedStatus = value!),
),

              const SizedBox(height: 12),
              ElevatedButton(
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
                child: Text(
                  'Date: ${selectedDateTime.day.toString().padLeft(2, '0')}/'
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
                status: AppointmentStatus.pending,
              ));
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
  
}
