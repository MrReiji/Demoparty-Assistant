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
    // Initialize timezone database
    tz.initializeTimeZones();
    final String localTimeZone = 'Europe/Warsaw';
    tz.setLocalLocation(tz.getLocation(localTimeZone));

    // Initialize settings for Android
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('notification_logo');

    // Initialize settings for iOS
    const DarwinInitializationSettings iOSInitializationSettings = DarwinInitializationSettings();

    // Combine initialization settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    // Initialize notifications plugin
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notification clicked with payload: ${response.payload}');
      },
      onDidReceiveBackgroundNotificationResponse: _handleBackgroundNotification,
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.max,
      playSound: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    print('Notification Service initialized with channel $_channelName.');
  }

  // Background notification handler
  static Future<void> _handleBackgroundNotification(NotificationResponse response) async {
    print('Background notification received with payload: ${response.payload}');
  }

  Future<void> scheduleEventNotification(
    String title,
    DateTime eventDateTime, {
    String? payload,
  }) async {
    final reminderTimeInMinutes = await _settingsService.getReminderTimeInMinutes();

    print('Raw eventDateTime (UTC): $eventDateTime');

    final tz.TZDateTime eventTZDateTime = tz.TZDateTime.from(eventDateTime.toUtc(), tz.local);
    final tz.TZDateTime scheduledDate = eventTZDateTime.subtract(Duration(minutes: reminderTimeInMinutes));

    print('Event time (local): $eventTZDateTime');
    print('Notification time (local): $scheduledDate');
    print('Current time (local): ${tz.TZDateTime.now(tz.local)}');

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
        print('Notification scheduled for "$title" at $scheduledDate.');
      } catch (e) {
        print('Error scheduling notification for "$title": $e');
      }
    } else {
      print('Event "$title" is in the past; no notification scheduled.');
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
    print('Notification with ID $id has been canceled.');
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
    print('All notifications have been canceled.');
  }
}
