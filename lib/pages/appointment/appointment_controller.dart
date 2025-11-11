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
          patient: Patient(
            nom: data['patientName'] ?? '',
            age: data['patientAge'] ?? 0,
            email: data['patientEmail'] ?? '',
          ),
          dateTime: (data['dateTime'] as Timestamp).toDate(),
          status: _parseStatus(data['status']),
        );
        log("AppointmentStatus ==== $appointment");
        print("eeeeeeeeeeeeeeeeeee :$appointment");
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
      await _firestore.collection('appointments').add({
        'patientName': appointment.patient.nom,
        'patientAge': appointment.patient.age,
        'patientEmail': appointment.patient.email,
        'dateTime': appointment.dateTime,
        'status': appointment.status.name,
      });

      _appointments.add(appointment);
      notifyListeners();
    } catch (e) {
      print("Error adding appointment: $e");
    }
  }

  /// Remove appointment from Firestore
  Future<void> removeAppointment(Appointment appointment) async {
    try {
      final query = await _firestore
          .collection('appointments')
          .where('patientEmail', isEqualTo: appointment.patient.email)
          .where('dateTime', isEqualTo: appointment.dateTime)
          .get();

      for (var doc in query.docs) {
        await _firestore.collection('appointments').doc(doc.id).delete();
      }

      _appointments.remove(appointment);
      notifyListeners();
    } catch (e) {
      print("Error deleting appointment: $e");
    }
  }

  /// Update appointment (only status and datetime can change logically)
  Future<void> updateAppointment(Appointment old, Appointment updated) async {
    try {
      final query = await _firestore
          .collection('appointments')
          .where('patientEmail', isEqualTo: old.patient.email)
          .where('dateTime', isEqualTo: old.dateTime)
          .get();

      for (var doc in query.docs) {
        await _firestore.collection('appointments').doc(doc.id).update({
          'dateTime': updated.dateTime,
          'status': updated.status.name,
        });
      }

      final index = _appointments.indexOf(old);
      if (index != -1) {
        _appointments[index] = updated;
      }

      notifyListeners();
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

    // If it's int (old stored version: 0,1,2,3)
    if (value is int) {
      return AppointmentStatus.values[value];
    }

    // Convert string to lowercase safely
    if (value is String) {
      String v = value.toLowerCase();
      switch (v) {
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
