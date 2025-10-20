import 'package:dentiste/models/appointment.dart';
import 'package:dentiste/models/patient.dart';
import 'package:flutter/material.dart';

class AppointmentController extends ChangeNotifier {
  final List<Appointment> appointments = [];

  void addAppointment(Appointment appointment) {
    appointments.add(appointment);
    notifyListeners();
  }

  void removeAppointment(Appointment appointment) {
    appointments.remove(appointment);
    notifyListeners();
  }

  List<Appointment> forPatient(Patient patient) {
    return appointments.where((a) => a.patient == patient).toList();
  }

  List<Appointment> forDate(DateTime date) {
  return appointments.where((a) =>
    a.dateTime.year == date.year &&
    a.dateTime.month == date.month &&
    a.dateTime.day == date.day
  ).toList();
  }
  
  void updateAppointment(Appointment old, Appointment updated) {
  final index = appointments.indexOf(old);
  if (index != -1) {
    appointments[index] = updated;
    notifyListeners();
  }
  } 


}
