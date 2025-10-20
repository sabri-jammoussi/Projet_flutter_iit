import 'package:dentiste/models/patient.dart';

enum AppointmentStatus { pending, confirmed, cancelled, completed }

class Appointment {
  final Patient patient;
  final DateTime dateTime;
  final String reason;
  AppointmentStatus status;

  Appointment({
    required this.patient,
    required this.dateTime,
    required this.reason,
    this.status = AppointmentStatus.pending,
  });
}
