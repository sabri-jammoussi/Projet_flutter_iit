import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/facture.dart';
import '../../models/patient.dart' ;

class BillingController extends ChangeNotifier {
  List<Facture> factures = [];
  late StreamSubscription _subscription;

  double totalFactures = 0.0;
  double totalPaye = 0.0;
  double totalPartiel = 0.0;
  double totalImpaye = 0.0;

  BillingController() {
    _listenToFactures();
  }

  void _listenToFactures() {
    _subscription = FirebaseFirestore.instance
        .collection('factures')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((snapshot) {
      factures = snapshot.docs
          .map((doc) => Facture.fromFirestore(doc))
          .where((f) => f != null)
          .cast<Facture>()
          .toList();
      _calculateTotals();
      notifyListeners();
    });
  }

  void _calculateTotals() {
    totalFactures = 0.0;
    totalPaye = 0.0;
    totalPartiel = 0.0;
    totalImpaye = 0.0;

    for (var f in factures) {
      totalFactures += f.montantTotal;
      totalPaye += f.montantPaye;

      if (f.resteAPayer == 0) {
        // payée
      } else if (f.montantPaye > 0) {
        totalPartiel += f.resteAPayer;
      } else {
        totalImpaye += f.montantTotal;
      }
    }
  }

  /// 🔍 Filtrer les factures pour un patient donné
  List<Facture> facturesPour(Patient patient) {
    return factures.where((f) => f.patient.nom.trim().toLowerCase() == patient.nom.trim().toLowerCase()).toList();
  }

  /// ➕ Ajouter une facture
  Future<void> addFacture(Facture facture) async {
    await FirebaseFirestore.instance.collection('factures').add(facture.toMap());
  }

  /// ✏️ Modifier une facture
  Future<void> updateFacture(Facture oldFacture, Facture updated) async {
    await FirebaseFirestore.instance
        .collection('factures')
        .doc(oldFacture.id)
        .update(updated.toMap());
  }

  /// ❌ Supprimer une facture
  Future<void> removeFacture(Facture facture) async {
    await FirebaseFirestore.instance
        .collection('factures')
        .doc(facture.id)
        .delete();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
