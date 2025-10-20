import 'package:dentiste/models/patient.dart';

enum StatutPaiement { paye, partiel, impaye }

class Facture {
  final Patient patient;
  final double montant;
  final DateTime date;
  final StatutPaiement statut;
  final String modePaiement;

  Facture({
    required this.patient,
    required this.montant,
    required this.date,
    required this.statut,
    required this.modePaiement,
  });
}
