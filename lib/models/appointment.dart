import 'package:dentiste/models/patient.dart';

enum AppointmentStatus { pending, confirmed, cancelled, completed }

class Appointment {
  final Patient patient;
  final DateTime dateTime;
  AppointmentStatus status;

  Appointment({
    required this.patient,
    required this.dateTime,
    this.status = AppointmentStatus.pending,
  });
}
