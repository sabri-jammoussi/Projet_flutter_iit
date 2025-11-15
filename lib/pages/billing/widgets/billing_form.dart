import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dentiste/models/facture.dart';
import 'package:dentiste/models/acte_medicale.dart';
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
    final montantTotal = soinsChoisis.fold<double>(0.0, (sum, soin) => sum + soin.tarif);
    final resteAPayer = (montantTotal - montantPaye).clamp(0.0, montantTotal);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Theme.of(context).cardColor,
      title: Text(
        widget.facture == null ? 'Nouvelle facture' : 'Modifier facture',
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
                decoration: _inputDecoration(context, 'Mode de paiement'),
                value: modePaiement,
                items: ['Espèces', 'Carte', 'Virement', 'Assurance'].map((m) {
                  return DropdownMenuItem(value: m, child: Text(m));
                }).toList(),
                onChanged: (value) => setState(() => modePaiement = value!),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Soins réalisés :',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              const SizedBox(height: 8),
              ...soinsDisponibles.map((soin) {
                return CheckboxListTile(
                  title: Text('${soin.nom} - ${soin.tarif.toStringAsFixed(2)} TND'),
                  value: soinsChoisis.contains(soin),
                  activeColor: Theme.of(context).primaryColor,
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
              Text('Montant total : ${montantTotal.toStringAsFixed(2)} TND',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              TextFormField(
                decoration: _inputDecoration(context, 'Montant payé'),
                initialValue: montantPaye.toString(),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final val = double.tryParse(value ?? '');
                  if (val == null || val < 0) {
                    return 'Veuillez entrer un montant valide';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    montantPaye = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              const SizedBox(height: 8),
              Text('Reste à payer : ${resteAPayer.toStringAsFixed(2)} TND',
                  style: Theme.of(context).textTheme.bodyMedium),
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

              final facture = Facture(
                id: widget.facture?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                patient: selectedPatient!,
                date: DateTime.now(),
                actes: soinsChoisis,
                montantTotal: montantTotal,
                montantPaye: montantPaye,
                resteAPayer: resteAPayer,
                modePaiement: modePaiement,
                statut: resteAPayer == 0 ? 'payée' : (montantPaye > 0 ? 'partielle' : 'impayée'),
              );

              widget.onSubmit(facture);
              Navigator.pop(context);
            }
          },
          child: Text(widget.facture == null ? 'Ajouter' : 'Modifier',
              style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Annuler', style: TextStyle(color: Colors.grey)),
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
