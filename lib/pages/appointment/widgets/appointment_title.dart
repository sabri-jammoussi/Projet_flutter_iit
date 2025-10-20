import 'package:flutter/material.dart';
import 'package:dentiste/models/appointment.dart';

class AppointmentTile extends StatelessWidget {
  final Appointment appointment;

  const AppointmentTile({required this.appointment, super.key});

  Color _statusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.confirmed:
        return Colors.green;
      case AppointmentStatus.cancelled:
        return Colors.red;
      case AppointmentStatus.completed:
        return Colors.grey;
      case AppointmentStatus.pending:
        return Colors.orange;
    }
  }

  String _statusLabel(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.confirmed:
        return 'Confirmé';
      case AppointmentStatus.cancelled:
        return 'Annulé';
      case AppointmentStatus.completed:
        return 'Terminé';
      case AppointmentStatus.pending:
        return 'En attente';
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = '${appointment.dateTime.hour.toString().padLeft(2, '0')}:${appointment.dateTime.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: Colors.teal),
        title: Text(appointment.patient.nom),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${appointment.reason} — $time'),
            const SizedBox(height: 6),
            Row(
              children: [
                const Text('Statut : '),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(appointment.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel(appointment.status),
                    style: const TextStyle(
                      color: Colors.pink,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
