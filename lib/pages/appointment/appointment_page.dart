import 'package:dentiste/pages/appointment/widgets/appointment_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dentiste/pages/appointment/appointment_controller.dart';
import 'package:dentiste/pages/appointment/widgets/appointment_calendar.dart';
import 'package:dentiste/pages/appointment/widgets/appointment_form.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AppointmentController>(context);
    final appointments = controller.forDate(selectedDate);

    return Scaffold(
      appBar: AppBar(title: const Text('Appointments')),
      body: Column(
        children: [
          AppointmentCalendar(
            selectedDate: selectedDate,
            onDateSelected: (date) => setState(() => selectedDate = date),
          ),
          Expanded(
            child: appointments.isEmpty
                ? const Center(child: Text('No appointments for this date.'))
                : ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      return AppointmentTile(appointment: appointments[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AppointmentForm(
              onSubmit: (newAppointment) {
                controller.addAppointment(newAppointment);
                Navigator.pop(context);
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
