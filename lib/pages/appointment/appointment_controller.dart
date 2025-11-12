import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentiste/models/appointment.dart';
import 'package:dentiste/models/patient.dart';
import 'package:flutter/material.dart';

class AppointmentController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Appointment> _appointments = [];
  List<Appointment> get appointments => List.unmodifiable(_appointments);

  /// Load all appointments from Firestore
  Future<void> loadAppointments() async {
    try {
      final snapshot = await _firestore.collection('appointments').get();
      _appointments.clear();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final appointment = Appointment(
          id: doc.id,
          patient: Patient(
            nom: data['patientName'] ?? '',
            age: data['patientAge'] ?? 0,
            email: data['patientEmail'] ?? '',
          ),
          dateTime: (data['dateTime'] as Timestamp).toDate(),
          status: _parseStatus(data['status']),
        );
        _appointments.add(appointment);
      }

      notifyListeners();
    } catch (e) {
      print("Error loading appointments: $e");
    }
  }

  /// Add appointment to Firestore
  Future<void> addAppointment(Appointment appointment) async {
    try {
      final docRef = await _firestore.collection('appointments').add({
        'patientName': appointment.patient.nom,
        'patientAge': appointment.patient.age,
        'patientEmail': appointment.patient.email,
        'dateTime': appointment.dateTime,
        'status': appointment.status.name,
      });

      final newAppointment = Appointment(
        id: docRef.id,
        patient: appointment.patient,
        dateTime: appointment.dateTime,
        status: appointment.status,
      );

      _appointments.add(newAppointment);
      notifyListeners();
    } catch (e) {
      print("Error adding appointment: $e");
    }
  }

  /// Remove appointment from Firestore
  Future<void> removeAppointment(Appointment appointment) async {
    try {
      await _firestore.collection('appointments').doc(appointment.id).delete();
      _appointments.removeWhere((a) => a.id == appointment.id);
      notifyListeners();
    } catch (e) {
      print("Error deleting appointment: $e");
    }
  }

  /// Update appointment (status and datetime)
  Future<void> updateAppointment(Appointment updated) async {
    try {
      await _firestore.collection('appointments').doc(updated.id).update({
        'dateTime': updated.dateTime,
        'status': updated.status.name,
      });

      final index = _appointments.indexWhere((a) => a.id == updated.id);
      if (index != -1) {
        _appointments[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      print("Error updating appointment: $e");
    }
  }

  /// Filter by patient
  List<Appointment> forPatient(Patient patient) {
    return _appointments
        .where((a) => a.patient.email == patient.email)
        .toList();
  }

  /// Filter by calendar day
  List<Appointment> forDate(DateTime date) {
    return _appointments.where((a) {
      return a.dateTime.year == date.year &&
          a.dateTime.month == date.month &&
          a.dateTime.day == date.day;
    }).toList();
  }

  /// Convert string -> enum
  AppointmentStatus _parseStatus(dynamic value) {
    log("🔥 RAW STATUS: $value (${value.runtimeType})");

    if (value == null) return AppointmentStatus.pending;

    if (value is int) {
      return AppointmentStatus.values[value];
    }

    if (value is String) {
      switch (value.toLowerCase()) {
        case "pending":
          return AppointmentStatus.pending;
        case "confirmed":
          return AppointmentStatus.confirmed;
        case "cancelled":
          return AppointmentStatus.cancelled;
        case "completed":
          return AppointmentStatus.completed;
      }
    }

    return AppointmentStatus.pending;
  }
}
