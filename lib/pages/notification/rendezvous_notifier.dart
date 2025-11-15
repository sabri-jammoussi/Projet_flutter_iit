import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_service.dart';

class RendezvousNotifier {
  Future<void> planifierTousLesRendezVous() async {
    final now = DateTime.now();
    final snapshot = await FirebaseFirestore.instance
        .collection('rendezvous')
        .where('dateTime', isGreaterThan: Timestamp.fromDate(now))
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final dateTime = (data['dateTime'] as Timestamp).toDate();
      final title = data['titre'] ?? 'Consultation';

      if (dateTime.isAfter(now.add(const Duration(minutes: 30)))) {
        await NotificationService().scheduleNotification(dateTime, title);
      }
    }
  }
}
