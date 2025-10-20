import 'package:flutter/material.dart';
import 'package:dentiste/models/patient.dart';

class PatientController extends ChangeNotifier {
  final List<Patient> _allPatients = [];
  List<Patient> _filteredPatients = [];

  List<Patient> get patients => _filteredPatients;

  void loadPatients() {
    _allPatients.addAll([
      Patient(nom: 'Ahmed Ben Salah', age: 45, email: 'ahmed@example.com'),
      Patient(nom: 'Leila Trabelsi', age: 32, email: 'leila@example.com'),
    ]);
    _filteredPatients = List.from(_allPatients);
    notifyListeners();
  }

  void addPatient(Patient patient) {
    _allPatients.add(patient);
    _filteredPatients = List.from(_allPatients);
    notifyListeners();
  }

  void removePatient(Patient patient) {
    _allPatients.remove(patient);
    _filteredPatients = List.from(_allPatients);
    notifyListeners();
  }

  void search(String query) {
    if (query.isEmpty) {
      _filteredPatients = List.from(_allPatients);
    } else {
      _filteredPatients = _allPatients
          .where((p) => p.nom.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
