import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dentiste/models/appointment.dart';
import 'package:dentiste/models/patient.dart';

class AppointmentController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Appointment> _appointments = [];
  List<Appointment> get appointments => List.unmodifiable(_appointments);

  /// 🔄 Charger tous les rendez-vous
  Future<void> loadAppointments() async {
    try {
      final snapshot = await _firestore.collection('appointments').get();
      _appointments.clear();

      for (var doc in snapshot.docs) {
        final appointment = Appointment.fromMap(doc.id, doc.data());
        _appointments.add(appointment);
      }

      notifyListeners();
    } catch (e) {
      log("❌ Error loading appointments: $e");
    }
  }

  /// ➕ Ajouter un rendez-vous
  Future<void> addAppointment(Appointment appointment) async {
    try {
      final docRef = await _firestore.collection('appointments').add(appointment.toMap());
      final newAppointment = appointment.copyWith(id: docRef.id);
      _appointments.add(newAppointment);
      notifyListeners();
    } catch (e) {
      log("❌ Error adding appointment: $e");
    }
  }

  /// 🗑️ Supprimer un rendez-vous
  Future<void> removeAppointment(Appointment appointment) async {
    try {
      await _firestore.collection('appointments').doc(appointment.id).delete();
      _appointments.removeWhere((a) => a.id == appointment.id);
      notifyListeners();
    } catch (e) {
      log("❌ Error deleting appointment: $e");
    }
  }

  /// ✏️ Modifier un rendez-vous (date, statut, patient)
  Future<void> updateAppointment(Appointment updated) async {
    try {
      await _firestore.collection('appointments').doc(updated.id).update(updated.toMap());
      final index = _appointments.indexWhere((a) => a.id == updated.id);
      if (index != -1) {
        _appointments[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      log("❌ Error updating appointment: $e");
    }
  }

  /// 🔍 Filtrer par patient
  List<Appointment> forPatient(Patient patient) {
    return _appointments.where((a) => a.patient.email == patient.email).toList();
  }

  /// 📅 Filtrer par date
  List<Appointment> forDate(DateTime date) {
    return _appointments.where((a) =>
      a.dateTime.year == date.year &&
      a.dateTime.month == date.month &&
      a.dateTime.day == date.day
    ).toList();
  }
}
