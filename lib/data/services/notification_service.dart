import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'settings_service.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final SettingsService _settingsService = SettingsService();

  // Notification channel constants
  static const String _channelId = 'event_channel';
  static const String _channelName = 'Event Notifications';
  static const String _channelDescription = 'This channel is used for event notifications';

  Future<void> initialize() async {
    print('[NotificationService] Initializing...');
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Warsaw'));
    print('[NotificationService] Timezone initialized to Europe/Warsaw.');

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('notification_logo'),
      iOS: DarwinInitializationSettings(),
    );
    await _notificationsPlugin.initialize(initializationSettings);
    print('[NotificationService] Plugin initialized.');

    const channel = AndroidNotificationChannel(
      'event_channel',
      'Event Notifications',
      description: 'Notifications for scheduled events',
      importance: Importance.max,
    );
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    print('[NotificationService] Notification channel created.');
  }

  // Background notification handler
  static Future<void> _handleBackgroundNotification(NotificationResponse response) async {
    print('[NotificationService] Background notification received with payload: ${response.payload}');
  }

  Future<void> scheduleEventNotification(
    String title,
    DateTime eventDateTime, {
    String? payload,
  }) async {
    print('[NotificationService] Scheduling notification...');
    print('[NotificationService] Title: $title');
    print('[NotificationService] Event DateTime (UTC): $eventDateTime');

    final reminderTimeInMinutes = await _settingsService.getReminderTimeInMinutes();
    print('[NotificationService] Reminder time set to $reminderTimeInMinutes minutes before the event.');

    final tz.TZDateTime eventTZDateTime = tz.TZDateTime.from(eventDateTime.toUtc(), tz.local);
    final tz.TZDateTime scheduledDate = eventTZDateTime.subtract(Duration(minutes: reminderTimeInMinutes));

    print('[NotificationService] Event time (local): $eventTZDateTime');
    print('[NotificationService] Notification scheduled time (local): $scheduledDate');
    print('[NotificationService] Current time (local): ${tz.TZDateTime.now(tz.local)}');

    if (scheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
      try {
        await _notificationsPlugin.zonedSchedule(
          eventDateTime.hashCode,
          title,
          'Your event "$title" starts in $reminderTimeInMinutes minutes!',
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

  Future<void> cancelNotification(int id) async {
    print('[NotificationService] Canceling notification with ID $id...');
    await _notificationsPlugin.cancel(id);
    print('[NotificationService] Notification with ID $id has been canceled.');
  }

  Future<void> cancelAllNotifications() async {
    print('[NotificationService] Canceling all notifications...');
    await _notificationsPlugin.cancelAll();
    print('[NotificationService] All notifications have been canceled.');
  }
}
