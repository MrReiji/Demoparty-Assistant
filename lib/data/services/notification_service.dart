import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:get_it/get_it.dart';
import 'settings_service.dart';
import 'package:demoparty_assistant/data/repositories/time_table_repository.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final SettingsService _settingsService = SettingsService();

  static const String _channelId = 'event_channel';
  static const String _channelName = 'Event Notifications';
  static const String _channelDescription = 'This channel is used for event notifications';

  Future<void> initialize() async {
    print('[NotificationService] Initializing...');
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('notification_logo'),
      iOS: DarwinInitializationSettings(),
    );
    await _notificationsPlugin.initialize(initializationSettings);
    print('[NotificationService] Plugin initialized.');

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.max,
    );
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    print('[NotificationService] Notification channel created.');
  }

  Future<void> scheduleEventNotification(
    String title,
    DateTime eventDateTime, {
    String? payload,
  }) async {
    final reminderTimeInMinutes = await _settingsService.getReminderTimeInMinutes();
    final tz.TZDateTime eventTZDateTime = tz.TZDateTime.from(eventDateTime.toUtc(), tz.local);
    final tz.TZDateTime scheduledDate = eventTZDateTime.subtract(Duration(minutes: reminderTimeInMinutes));

    if (scheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
      try {
        await _notificationsPlugin.zonedSchedule(
          eventDateTime.hashCode,
          title,
          'Your event "$title" starts soon!',
          scheduledDate,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channelId,
              _channelName,
              channelDescription: _channelDescription,
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              icon: 'notification_logo',
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload,
        );
        print('[NotificationService] Notification scheduled for "$title" at $scheduledDate.');
      } catch (e) {
        print('[NotificationService] Error scheduling notification for "$title": $e');
      }
    } else {
      print('[NotificationService] Event "$title" is in the past; no notification scheduled.');
    }
  }

  Future<void> cancelAllNotifications() async {
    print('[NotificationService] Canceling all notifications...');
    await _notificationsPlugin.cancelAll();
    print('[NotificationService] All notifications have been canceled.');
  }

  Future<void> rescheduleAllNotifications() async {
    print('[NotificationService] Re-scheduling all notifications...');
    try {
      final timetableRepository = GetIt.I<TimeTableRepository>();
      final events = timetableRepository.eventsData;

      for (final day in events) {
        final date = day['date'] as String;
        final eventsList = day['events'] as List<dynamic>;

        for (final event in eventsList) {
          final eventMap = Map<String, dynamic>.from(event as Map);
          final time = eventMap['time'] as String;
          final eventDateTime = timetableRepository.parseDateTimeFromCache(date, time);

          if (eventDateTime != null && eventDateTime.isAfter(DateTime.now())) {
            await scheduleEventNotification(
              eventMap['description'] ?? 'Event',
              eventDateTime,
              payload: eventMap['type'] ?? 'General',
            );
          }
        }
      }
      print('[NotificationService] All notifications re-scheduled successfully.');
    } catch (e) {
      print('[NotificationService] Error re-scheduling notifications: $e');
    }
  }
}
