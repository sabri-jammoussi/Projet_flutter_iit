import 'package:dentiste/models/acte_medicale.dart';
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
  double montantPaye = 0.0;
  String modePaiement = 'Espèces';

  // Soins disponibles
  final List<ActeMedical> soinsDisponibles = [
    ActeMedical(nom: 'Consultation', tarif: 50.0),
    ActeMedical(nom: 'Détartrage', tarif: 80.0),
    ActeMedical(nom: 'Extraction', tarif: 100.0),
  ];

  List<ActeMedical> soinsChoisis = [];

  @override
  void initState() {
    super.initState();
    selectedPatient = widget.facture?.patient ?? widget.patient;
    montantPaye = widget.facture?.montantPaye ?? 0.0;
    modePaiement = widget.facture?.modePaiement ?? 'Espèces';
    soinsChoisis = widget.facture?.actes ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final patients = Provider.of<PatientController>(context).patients;

    double montantTotal = soinsChoisis.fold(0, (sum, soin) => sum + soin.tarif);

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
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Mode de paiement'),
                value: modePaiement,
                items: ['Espèces', 'Carte', 'Virement', 'Assurance'].map((m) {
                  return DropdownMenuItem(value: m, child: Text(m));
                }).toList(),
                onChanged: (value) => setState(() => modePaiement = value!),
              ),
              const SizedBox(height: 12),
              const Text('Soins réalisés :', style: TextStyle(fontWeight: FontWeight.bold)),
              ...soinsDisponibles.map((soin) {
                return CheckboxListTile(
                  title: Text('${soin.nom} - ${soin.tarif.toStringAsFixed(2)} TND'),
                  value: soinsChoisis.contains(soin),
                  onChanged: (selected) {
                    setState(() {
                      selected!
                          ? soinsChoisis.add(soin)
                          : soinsChoisis.remove(soin);
                    });
                  },
                );
              }).toList(),
              const SizedBox(height: 12),
              Text('Montant total : ${montantTotal.toStringAsFixed(2)} TND'),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Montant payé'),
                initialValue: montantPaye.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    montantPaye = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              if (soinsChoisis.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Veuillez sélectionner au moins un soin')),
                );
                return;
              }

              widget.onSubmit(Facture(
                id: widget.facture?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                patient: selectedPatient!,
                date: DateTime.now(),
                actes: soinsChoisis,
                montantPaye: montantPaye,
                modePaiement: modePaiement,
              ));
              Navigator.pop(context);
            }
          },
          child: Text(widget.facture == null ? 'Ajouter' : 'Modifier'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}
