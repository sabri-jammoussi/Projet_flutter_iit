import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);
  }

  Future<void> scheduleNotification(DateTime rendezVousDateTime, String title) async {
    final scheduledDate = tz.TZDateTime.from(
      rendezVousDateTime.subtract(const Duration(minutes: 30)),
      tz.local,
    );

    await _plugin.zonedSchedule(
      rendezVousDateTime.hashCode,
      '⏰ Rappel de rendez-vous',
      'Votre rendez-vous "$title" est dans 30 minutes.',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'rdv_channel',
          'Rappels de rendez-vous',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}
