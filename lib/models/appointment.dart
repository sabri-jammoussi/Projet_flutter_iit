import 'package:dentiste/models/patient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AppointmentStatus { pending, confirmed, cancelled, completed }

class Appointment {
  final String?id;
  final Patient patient;
  final DateTime dateTime;
  final AppointmentStatus status;

  Appointment({
    this.id,
    required this.patient,
    required this.dateTime,
    required this.status,
  });

  /// 🔁 Créer une copie modifiée
  Appointment copyWith({
    String? id,
    Patient? patient,
    DateTime? dateTime,
    AppointmentStatus? status,
  }) {
    return Appointment(
      id: id ?? this.id,
      patient: patient ?? this.patient,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
    );
  }

  /// 📤 Convertir vers Firestore
  Map<String, dynamic> toMap() {
    return {
      'patientName': patient.nom,
      'patientAge': patient.age,
      'patientEmail': patient.email,
      'dateTime': dateTime,
      'status': status.name,
    };
  }

  /// 📥 Reconstruire depuis Firestore
  factory Appointment.fromMap(String id, Map<String, dynamic> map) {
    return Appointment(
      id: id,
      patient: Patient(
        nom: map['patientName'] ?? '',
        age: map['patientAge'] ?? 0,
        email: map['patientEmail'] ?? '',
      ),
      dateTime: (map['dateTime'] as Timestamp).toDate(),
      status: _parseStatus(map['status']),
    );
  }

  /// 🔁 Convertir string/int -> enum
  static AppointmentStatus _parseStatus(dynamic value) {
    if (value == null) return AppointmentStatus.pending;

    if (value is int && value >= 0 && value < AppointmentStatus.values.length) {
      return AppointmentStatus.values[value];
    }

    if (value is String) {
      switch (value.toLowerCase()) {
        case "pending": return AppointmentStatus.pending;
        case "confirmed": return AppointmentStatus.confirmed;
        case "cancelled": return AppointmentStatus.cancelled;
        case "completed": return AppointmentStatus.completed;
      }
    }

    return AppointmentStatus.pending;
  }
}
