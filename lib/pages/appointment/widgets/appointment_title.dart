import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dentiste/models/appointment.dart';
import 'package:dentiste/pages/appointment/appointment_controller.dart';

class AppointmentTile extends StatelessWidget {
  final Appointment appointment;

  const AppointmentTile({required this.appointment, super.key});

  Color _statusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.confirmed:
        return Colors.green.shade600;
      case AppointmentStatus.cancelled:
        return Colors.red.shade600;
      case AppointmentStatus.completed:
        return Colors.grey.shade600;
      case AppointmentStatus.pending:
        return Colors.orange.shade600;
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

  String _formattedDateTime(DateTime dateTime) {
    final date = '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year}';
    final time = '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
    return '$date à $time';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: const Icon(Icons.calendar_today, color: Colors.teal),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    appointment.patient.nom,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.teal),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => _buildEditDialog(context),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Supprimer le rendez-vous'),
                        content: const Text('Voulez-vous vraiment supprimer ce rendez-vous ?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<AppointmentController>(context, listen: false)
                                  .removeAppointment(appointment);
                              Navigator.pop(context);
                            },
                            child: const Text('Supprimer'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Rendez-vous — ${_formattedDateTime(appointment.dateTime)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text('Statut : ', style: Theme.of(context).textTheme.bodyMedium),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(appointment.status).withOpacity(0.2),
                    border: Border.all(color: _statusColor(appointment.status)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel(appointment.status),
                    style: TextStyle(
                      color: _statusColor(appointment.status),
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

  /// ✅ Méthode privée pour afficher le dialogue de modification
  Widget _buildEditDialog(BuildContext context) {
    DateTime selectedDate = appointment.dateTime;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(appointment.dateTime);
    AppointmentStatus selectedStatus = appointment.status;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text('Modifier le rendez-vous'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Date'),
                subtitle: Text('${selectedDate.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => selectedDate = picked);
                },
              ),
              ListTile(
                title: const Text('Heure'),
                subtitle: Text(selectedTime.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (picked != null) setState(() => selectedTime = picked);
                },
              ),
              DropdownButtonFormField<AppointmentStatus>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: 'Statut'),
                items: AppointmentStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => selectedStatus = value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                final updated = appointment.copyWith(
                  dateTime: updatedDateTime,
                  status: selectedStatus,
                );

                Provider.of<AppointmentController>(context, listen: false)
                    .updateAppointment(updated);

                Navigator.pop(context);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }
}
