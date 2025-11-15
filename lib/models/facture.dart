import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentiste/models/acte_medicale.dart';
import 'package:dentiste/models/patient.dart';

enum StatutPaiement {
  paye,
  partiel,
  impaye,
}

extension StatutPaiementExtension on StatutPaiement {
  String get label {
    switch (this) {
      case StatutPaiement.paye:
        return 'Payée';
      case StatutPaiement.partiel:
        return 'Partielle';
      case StatutPaiement.impaye:
        return 'Impayée';
    }
  }

  static StatutPaiement fromString(String value) {
    switch (value.toLowerCase()) {
      case 'payée':
      case 'paye':
        return StatutPaiement.paye;
      case 'partielle':
      case 'partiel':
        return StatutPaiement.partiel;
      case 'impayée':
      case 'impaye':
        return StatutPaiement.impaye;
      default:
        return StatutPaiement.impaye;
    }
  }
}

class Facture {
  final String? id;
  final Patient patient;
  final List<ActeMedical> actes;
  final double montantTotal;
  final double montantPaye;
  final double resteAPayer;
  final String modePaiement;
  final String statut;
  final DateTime date;

  Facture({
    this.id,
    required this.patient,
    required this.actes,
    required this.montantTotal,
    required this.montantPaye,
    required this.resteAPayer,
    required this.modePaiement,
    required this.statut,
    required this.date,
  });

  /// 🔁 Conversion du statut en enum
  StatutPaiement get statutEnum => StatutPaiementExtension.fromString(statut);

  factory Facture.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Facture(
      id: doc.id,
      patient: Patient.fromMap(data['patient'] ?? {}),
      actes: (data['actes'] as List<dynamic>)
          .map((a) => ActeMedical.fromMap(a as Map<String, dynamic>))
          .toList(),
      montantTotal: (data['montantTotal'] as num).toDouble(),
      montantPaye: (data['montantPaye'] as num).toDouble(),
      resteAPayer: (data['resteAPayer'] as num).toDouble(),
      modePaiement: data['modePaiement'] ?? '',
      statut: data['statut'] ?? 'impaye',
      date: (data['dateTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patient': patient.toMap(),
      'actes': actes.map((a) => a.toMap()).toList(),
      'montantTotal': montantTotal,
      'montantPaye': montantPaye,
      'resteAPayer': resteAPayer,
      'modePaiement': modePaiement,
      'statut': statut,
      'dateTime': Timestamp.fromDate(date),
    };
  }
}
