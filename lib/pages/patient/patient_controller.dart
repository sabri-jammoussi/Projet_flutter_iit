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
          id: doc.id, // 🔹 store Firestore document ID
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
  Future<Patient?> addPatient(Patient patient) async {
    try {
      final docRef = await _firestore.collection('patients').add({
        'nom': patient.nom,
        'age': patient.age,
        'email': patient.email,
      });

      final newPatient = Patient(
        id: docRef.id,
        nom: patient.nom,
        age: patient.age,
        email: patient.email,
      );

      _allPatients.add(newPatient);
      _filteredPatients = List.from(_allPatients);
      notifyListeners();

      print("Patient added with ID: ${docRef.id}");
      return newPatient; // ✅ return the patient with ID
    } catch (e) {
      print("Error adding patient: $e");
      return null;
    }
  }

  /// Remove a patient from Firestore
  Future<void> removePatient(Patient patient) async {
    try {
      if (patient.id != null && patient.id!.isNotEmpty) {
        await _firestore.collection('patients').doc(patient.id).delete();
      } else {
        // fallback if id is missing
        final query = await _firestore
            .collection('patients')
            .where('nom', isEqualTo: patient.nom)
            .get();

        for (var doc in query.docs) {
          await _firestore.collection('patients').doc(doc.id).delete();
        }
      }

      _allPatients.removeWhere((p) => p.id == patient.id);
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
