import 'package:android_intent_plus/android_intent.dart';

class NativeCalendarService {
  Future<void> addEventToNativeCalendar({
    required String title,
    required DateTime start,
    required DateTime end,
    String? description,
    String? location,
    bool allDay = false,
  }) async {
    try {
      final intent = AndroidIntent(
        action: 'android.intent.action.INSERT',
        data: 'content://com.android.calendar/events',
        type: "vnd.android.cursor.dir/event",
        arguments: <String, dynamic>{
          'title': title,
          'allDay': allDay,
          'beginTime': start.millisecondsSinceEpoch,
          'endTime': end.millisecondsSinceEpoch,
          'description': description ?? '',
          'eventLocation': location ?? '',
          'hasAlarm': 1,
        },
      );

      await intent.launchChooser("Choose an app to save the event");
    } catch (e) {
      print('Error while adding event to native calendar: $e');
    }
  }
}
