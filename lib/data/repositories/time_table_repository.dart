import 'dart:convert';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:demoparty_assistant/data/services/NativeCalendarService.dart';
import 'package:demoparty_assistant/data/services/cache_service.dart';
import 'package:demoparty_assistant/data/services/notification_service.dart';
import 'package:demoparty_assistant/utils/functions/getColorForType.dart';
import 'package:demoparty_assistant/utils/functions/getIconForType.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TimeTableRepository {
  final CacheService _cacheService;
  final NotificationService _notificationService;
  final NativeCalendarService _nativeCalendarService;

  List<Map<String, dynamic>> eventsData = [];
  DateTime? startDate;
  DateTime? endDate;
  int dateOffset = 83;

  TimeTableRepository(
    this._cacheService,
    this._notificationService,
    this._nativeCalendarService,
  );

  Future<void> loadOnboardingDates() async {
    try {
      print('[TimeTableRepository] Loading onboarding dates...');
      final jsonString = await rootBundle.loadString('assets/data/onboarding_data.json');
      final jsonData = json.decode(jsonString);

      if (jsonData.containsKey('startDate') && jsonData.containsKey('endDate')) {
        startDate = DateTime.tryParse(jsonData['startDate']);
        endDate = DateTime.tryParse(jsonData['endDate']);

        if (startDate == null || endDate == null) {
          throw Exception('Invalid date format in onboarding data.');
        }
        print('[TimeTableRepository] Onboarding dates loaded: startDate=$startDate, endDate=$endDate.');
      } else {
        throw Exception('Onboarding data is missing required keys.');
      }
    } catch (e) {
      print('[TimeTableRepository] Error loading onboarding dates: $e');
      throw Exception('Failed to load onboarding dates: $e');
    }
  }

  Future<void> fetchTimetable({bool applyOffset = true}) async {
  const cacheKey = 'timetable_data';
  print('[TimeTableRepository] Fetching timetable data...');

  final cachedData = _cacheService.get(cacheKey);
  if (cachedData != null) {
    print('[TimeTableRepository] Using cached timetable data.');
    try {
      eventsData = (cachedData as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      // Schedule notifications even for cached data
      _scheduleNotificationsForCachedData();
      return;
    } catch (e) {
      print('[TimeTableRepository] Error processing cached data: $e');
      throw Exception('Failed to process cached timetable data: $e');
    }
  }

  try {
    final response = await http.get(Uri.parse('https://party.xenium.rocks/timetable'));
    if (response.statusCode == 200) {
      print('[TimeTableRepository] Raw HTML response fetched.');
      final document = BeautifulSoup(response.body);
      final days = document.findAll('h2');
      final tables = document.findAll('.events');

      if (days.isEmpty || tables.isEmpty) {
        throw Exception('No timetable data found in server response.');
      }

      eventsData = _processTimetableData(days, tables, applyOffset);
      if (eventsData.isNotEmpty) {
        final normalizedData = eventsData.map((e) => Map<String, dynamic>.from(e)).toList();
        await _cacheService.set(cacheKey, normalizedData, 3600); // Cache with 1 hour TTL
        print('[TimeTableRepository] Timetable data successfully fetched and cached.');
      } else {
        throw Exception('Processed timetable data is empty.');
      }
    } else {
      throw Exception('HTTP ${response.statusCode}: Failed to fetch timetable data.');
    }
  } catch (e) {
    print('[TimeTableRepository] Error fetching timetable data: $e');
    throw Exception('Error fetching timetable data: $e');
  }
}

 void _scheduleNotificationsForCachedData() {
  print('[TimeTableRepository] Scheduling notifications for cached data...');
  for (final day in eventsData) {
    final date = day['date'] as String;
    final events = day['events'] as List<dynamic>;

    for (final event in events) {
      final eventMap = Map<String, dynamic>.from(event as Map);
      final time = eventMap['time'] as String;
      final eventDateTime = parseDateTimeFromCache(date, time);
      if (eventDateTime != null && eventDateTime.isAfter(DateTime.now())) {
        _notificationService.scheduleEventNotification(
          eventMap['description'] ?? 'Event',
          eventDateTime,
          payload: eventMap['type'] ?? 'General',
        );
      }
    }
  }
}

  DateTime? parseDateTimeFromCache(String date, String time) {
  try {
    final dateMatch = RegExp(r'\((\d{4}-\d{2}-\d{2})\)').firstMatch(date);
    if (dateMatch != null) {
      final dateStr = dateMatch.group(1)!;
      final parsedDate = DateTime.parse(dateStr);
      final timeParts = time.split(':');
      return DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    }
  } catch (e) {
    print('[TimeTableRepository] Error parsing date and time from cache: $e');
  }
  return null;
}

  List<Map<String, dynamic>> _processTimetableData(
    List<Bs4Element> days,
    List<Bs4Element> tables,
    bool applyOffset,
  ) {
    final weekdayToDateMap = _generateDateMap();

    return List.generate(days.length, (i) {
      final dayName = days[i].text.trim();
      DateTime? parsedDate = weekdayToDateMap[dayName];

      if (parsedDate == null) {
        print('[TimeTableRepository] Warning: No matching date for day name: $dayName');
        return null; // Ignore unmatched days
      }

      if (applyOffset) parsedDate = parsedDate.add(Duration(days: dateOffset));

      final formattedDate =
          "${DateFormat('EEEE').format(parsedDate)} (${DateFormat('yyyy-MM-dd').format(parsedDate)})";
      final eventRows = tables[i].findAll('tr');
      String lastKnownTime = '';

      final events = eventRows.map<Map<String, dynamic>>((row) {
        final rawTime = row.children[0].text.trim();
        final time = rawTime.isNotEmpty ? rawTime : lastKnownTime;
        if (rawTime.isNotEmpty) lastKnownTime = rawTime;

        final eventData = {
          'time': time,
          'type': row.children[1].text.trim(),
          'description': row.children[2].text.trim(),
          'icon': getIconForType(row.children[1].text.trim()).codePoint,
          'fontFamily': getIconForType(row.children[1].text.trim()).fontFamily,
          'color': getColorForType(row.children[1].text.trim()).value,
        };

        // Schedule notifications for each event
        _scheduleNotificationForEvent(parsedDate!, time, eventData);

        return eventData;
      }).toList();

      return {
        'date': formattedDate,
        'events': events,
      };
    }).whereType<Map<String, dynamic>>().toList(); // Filter null values
  }

  void _scheduleNotificationForEvent(DateTime date, String time, Map<String, dynamic> eventData) {
    try {
      final timeParts = time.split(':');
      final eventDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );

      _notificationService.scheduleEventNotification(
        eventData['description'] ?? 'Event',
        eventDateTime,
        payload: eventData['type'] ?? 'General',
      );
      print('[TimeTableRepository] Notification scheduled for event "${eventData['description']}" at $eventDateTime.');
    } catch (e) {
      print('[TimeTableRepository] Error scheduling notification: $e');
    }
  }

  Map<String, DateTime> _generateDateMap() {
    if (startDate == null || endDate == null) {
      throw Exception('Onboarding dates are not loaded.');
    }

    final map = <String, DateTime>{};
    var currentDate = startDate!;
    while (!currentDate.isAfter(endDate!)) {
      final weekday = DateFormat('EEEE').format(currentDate);
      map[weekday] = currentDate;
      currentDate = currentDate.add(const Duration(days: 1));
    }
    return map;
  }

  Future<void> addEventToCalendar(String date, String time, String description, String type) async {
    final match = RegExp(r'\((\d{4}-\d{2}-\d{2})\)').firstMatch(date);
    if (match != null) {
      final dateStr = match.group(1)!;
      final parsedDate = DateTime.parse(dateStr);
      final timeParts = time.split(':');
      final eventStartTime = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );

      await _nativeCalendarService.addEventToNativeCalendar(
        title: description,
        start: eventStartTime,
        end: eventStartTime.add(const Duration(hours: 1)),
        description: type,
        location: 'Default Location',
        allDay: false,
      );
      print('[TimeTableRepository] Event added to calendar: $description at $eventStartTime.');
    }
  }
}
