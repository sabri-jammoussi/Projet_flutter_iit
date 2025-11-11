import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentiste/models/acte_medicale.dart';
import 'package:dentiste/models/facture.dart';
import 'package:dentiste/models/patient.dart';
import 'package:flutter/material.dart';

class BillingController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Facture> _factures = [];
  List<Facture> get factures => _factures;

  // ---------- COMPUTED TOTALS ----------
  double get totalFactures =>
      factures.fold(0.0, (sum, f) => sum + f.montantPaye);

  double get totalPaye => factures
      .where((f) => f.statut == StatutPaiement.paye)
      .fold(0.0, (sum, f) => sum + f.montantPaye);

  double get totalPartiel => factures
      .where((f) => f.statut == StatutPaiement.partiel)
      .fold(0.0, (sum, f) => sum + f.montantPaye);

  double get totalImpaye => factures
      .where((f) => f.statut == StatutPaiement.impaye)
      .fold(0.0, (sum, f) => sum + f.montantPaye);

  // ---------- LOAD FACTURES FROM FIRESTORE ----------
  Future<void> loadFactures() async {
    try {
      final snapshot = await _firestore.collection('factures').get();

      _factures.clear();

      for (var doc in snapshot.docs) {
        final data = doc.data();

        // Parse actes
        List<ActeMedical> actes = [];
        if (data['actes'] != null) {
          actes = (data['actes'] as List).map((x) {
            return ActeMedical(
              nom: x['nom'] ?? '',
              tarif: (x['tarif'] ?? 0).toDouble(),
            );
          }).toList();
        }

        final facture = Facture(
          id: data['id'],
          patient: Patient(
            nom: data['patientName'] ?? '',
            age: data['patientAge'] ?? 0,
            email: data['patientEmail'] ?? '',
          ),
          date: (data['date'] as Timestamp).toDate(),
          actes: actes,
          montantPaye: (data['montantPaye'] ?? 0).toDouble(),
          modePaiement: data['modePaiement'] ?? '',
        );

        _factures.add(facture);
      }

      notifyListeners();
    } catch (e) {
      print("Error loading factures: $e");
    }
  }

  // ---------- ADD FACTURE ----------
  Future<void> addFacture(Facture facture) async {
    try {
      await _firestore.collection('factures').doc(facture.id).set({
        'id': facture.id,
        'patientName': facture.patient.nom,
        'patientAge': facture.patient.age,
        'patientEmail': facture.patient.email,
        'date': facture.date,
        'actes':
            facture.actes.map((a) => {'nom': a.nom, 'tarif': a.tarif}).toList(),
        'montantPaye': facture.montantPaye,
        'modePaiement': facture.modePaiement,
      });

      _factures.add(facture);
      notifyListeners();
    } catch (e) {
      print("Error adding facture: $e");
    }
  }

  // ---------- REMOVE FACTURE ----------
  Future<void> removeFacture(Facture facture) async {
    try {
      await _firestore.collection('factures').doc(facture.id).delete();

      _factures.remove(facture);
      notifyListeners();
    } catch (e) {
      print("Error removing facture: $e");
    }
  }

  // ---------- UPDATE FACTURE ----------
  Future<void> updateFacture(Facture oldFacture, Facture newFacture) async {
    try {
      await _firestore.collection('factures').doc(oldFacture.id).update({
        'date': newFacture.date,
        'actes': newFacture.actes
            .map((a) => {'nom': a.nom, 'tarif': a.tarif})
            .toList(),
        'montantPaye': newFacture.montantPaye,
        'modePaiement': newFacture.modePaiement,
      });

      // Local update
      final index = _factures.indexOf(oldFacture);
      if (index != -1) _factures[index] = newFacture;

      notifyListeners();
    } catch (e) {
      print("Error updating facture: $e");
    }
  }

  // ---------- FILTER BY PATIENT ----------
  List<Facture> facturesPour(Patient patient) {
    return factures.where((f) => f.patient.email == patient.email).toList();
  }
}
