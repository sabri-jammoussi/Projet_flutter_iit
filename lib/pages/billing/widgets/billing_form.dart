import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dentiste/models/facture.dart';
import 'package:dentiste/models/patient.dart';
import 'package:dentiste/pages/patient/patient_controller.dart';

class BillingForm extends StatefulWidget {
  final void Function(Facture) onSubmit;
  final Patient? patient;
  final Facture? facture;

  const BillingForm({
    required this.onSubmit,
    this.patient,
    this.facture,
    super.key,
  });

  @override
  State<BillingForm> createState() => _BillingFormState();
}

class _BillingFormState extends State<BillingForm> {
  final _formKey = GlobalKey<FormState>();
  Patient? selectedPatient;
  double montant = 0.0;
  StatutPaiement statut = StatutPaiement.impaye;
  String modePaiement = 'Espèces';

  @override
  void initState() {
    super.initState();
    selectedPatient = widget.facture?.patient ?? widget.patient;
    montant = widget.facture?.montant ?? 0.0;
    statut = widget.facture?.statut ?? StatutPaiement.impaye;
    modePaiement = widget.facture?.modePaiement ?? 'Espèces';
  }

  @override
  Widget build(BuildContext context) {
    final patients = Provider.of<PatientController>(context).patients;

    return AlertDialog(
      title: Text(widget.facture == null ? 'Nouvelle facture' : 'Modifier facture'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Patient>(
                decoration: const InputDecoration(labelText: 'Patient'),
                value: selectedPatient,
                items: patients.map((patient) {
                  return DropdownMenuItem(
                    value: patient,
                    child: Text(patient.nom),
                  );
                }).toList(),
                onChanged: widget.patient == null && widget.facture == null
                    ? (value) => setState(() => selectedPatient = value)
                    : null,
                validator: (value) =>
                    value == null ? 'Veuillez sélectionner un patient' : null,
              ),
              TextFormField(
                initialValue: montant.toString(),
                decoration: const InputDecoration(labelText: 'Montant'),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    montant = double.tryParse(value ?? '') ?? 0.0,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Champ requis' : null,
              ),
              DropdownButtonFormField<StatutPaiement>(
                decoration:
                    const InputDecoration(labelText: 'Statut de paiement'),
                value: statut,
                items: StatutPaiement.values.map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text(s.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => statut = value!),
              ),
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Mode de paiement'),
                value: modePaiement,
                items: ['Espèces', 'Carte', 'Virement', 'Assurance'].map((m) {
                  return DropdownMenuItem(value: m, child: Text(m));
                }).toList(),
                onChanged: (value) => setState(() => modePaiement = value!),
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
              widget.onSubmit(Facture(
                patient: selectedPatient!,
                montant: montant,
                date: DateTime.now(),
                statut: statut,
                modePaiement: modePaiement,
              ));
              Navigator.pop(context);
            }
          },
          child: Text(widget.facture == null ? 'Ajouter' : 'Modifier'),
        ),
      ],
    );
  }
}
