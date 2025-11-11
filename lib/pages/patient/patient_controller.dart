import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentiste/models/patient.dart';

class PatientController extends ChangeNotifier {
  final List<Patient> _allPatients = [];
  List<Patient> _filteredPatients = [];

  List<Patient> get patients => _filteredPatients;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Load patients from Firestore
  Future<void> loadPatients() async {
    try {
      final snapshot = await _firestore.collection('patients').get();

      _allPatients.clear();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        _allPatients.add(Patient(
          nom: data['nom'] ?? '',
          age: data['age'] ?? 0,
          email: data['email'] ?? '',
        ));
      }

      _filteredPatients = List.from(_allPatients);
      notifyListeners();
    } catch (e) {
      print("Error loading patients: $e");
    }
  }

  /// Add a patient to Firestore
  Future<void> addPatient(Patient patient) async {
    try {
      final docRef = await _firestore.collection('patients').add({
        'nom': patient.nom,
        'age': patient.age,
        'email': patient.email,
      });
      print("Patient added with ID: ${docRef.id}");

      _allPatients.add(patient);
      _filteredPatients = List.from(_allPatients);
      notifyListeners();
    } catch (e) {
      print("Error adding patient: $e");
    }
  }

  /// Remove a patient from Firestore
  Future<void> removePatient(Patient patient) async {
    try {
      final query = await _firestore
          .collection('patients')
          .where('nom', isEqualTo: patient.nom)
          .get();

      for (var doc in query.docs) {
        await _firestore.collection('patients').doc(doc.id).delete();
      }

      _allPatients.remove(patient);
      _filteredPatients = List.from(_allPatients);
      notifyListeners();
    } catch (e) {
      print("Error removing patient: $e");
    }
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
