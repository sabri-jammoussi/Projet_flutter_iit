import 'package:dentiste/models/acte_medicale.dart';
import 'package:dentiste/models/patient.dart';

enum StatutPaiement { paye, partiel, impaye }

class Facture {
  final String id;
  final Patient patient;
  final DateTime date;
  final List<ActeMedical> actes;
  final double montantPaye;
  final String modePaiement;

  Facture({
    required this.id,
    required this.patient,
    required this.date,
    required this.actes,
    required this.montantPaye,
    required this.modePaiement,
  });

  double get montantTotal => actes.fold(0, (sum, acte) => sum + acte.tarif);

  double get resteAPayer => montantTotal - montantPaye;

  StatutPaiement get statut {
    if (montantPaye >= montantTotal) return StatutPaiement.paye;
    if (montantPaye > 0) return StatutPaiement.partiel;
    return StatutPaiement.impaye;
  }
}
