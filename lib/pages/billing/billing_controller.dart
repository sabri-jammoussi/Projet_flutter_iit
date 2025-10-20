import 'package:dentiste/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:dentiste/models/facture.dart';

class BillingController extends ChangeNotifier {
  final List<Facture> _factures = [];

  List<Facture> get factures => _factures;
double get totalFactures =>
    factures.fold(0.0, (sum, f) => sum + f.montant);

double get totalPaye =>
    factures.where((f) => f.statut == StatutPaiement.paye)
            .fold(0.0, (sum, f) => sum + f.montant);

double get totalPartiel =>
    factures.where((f) => f.statut == StatutPaiement.partiel)
            .fold(0.0, (sum, f) => sum + f.montant);

double get totalImpaye =>
    factures.where((f) => f.statut == StatutPaiement.impaye)
            .fold(0.0, (sum, f) => sum + f.montant);

  void loadFactures() {
  _factures.addAll([]);
    notifyListeners();
  }

  void addFacture(Facture facture) {
    _factures.add(facture);
    notifyListeners();
  }

  void removeFacture(Facture facture) {
    _factures.remove(facture);
    notifyListeners();
  }
  List<Facture> facturesPour(Patient patient) =>
    factures.where((f) => f.patient == patient).toList();
    
  void updateFacture(Facture oldFacture, Facture newFacture) {
  final index = factures.indexOf(oldFacture);
  if (index != -1) {
    factures[index] = newFacture;
    notifyListeners();
  }
}

}
