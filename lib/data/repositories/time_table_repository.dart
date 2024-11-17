import 'dart:convert';
import 'package:demoparty_assistant/data/services/notification_service.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:demoparty_assistant/utils/functions/getIconForType.dart';
import 'package:demoparty_assistant/utils/functions/getColorForType.dart';
import 'package:demoparty_assistant/data/services/NativeCalendarService.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimeTableRepository {
  List<Map<String, dynamic>> eventsData = [];
  final NotificationService _notificationService;
  final NativeCalendarService nativeCalendarService = NativeCalendarService();
  int dateOffset = 79; // Kontrolowany przez dewelopera

  DateTime? startDate;
  DateTime? endDate;

  TimeTableRepository(this._notificationService);

  Future<void> initializeServices() async {
    tz.initializeTimeZones(); // Inicjalizacja danych stref czasowych
    await _notificationService.initialize();
    await _loadOnboardingDates();
    print('Services and dates initialized in TimeTableRepository');
  }

  Future<void> _loadOnboardingDates() async {
    final jsonString = await rootBundle.loadString('assets/data/onboarding_data.json');
    final jsonData = json.decode(jsonString);
    startDate = DateTime.parse(jsonData['startDate']);
    endDate = DateTime.parse(jsonData['endDate']);
    print('Loaded dates from JSON: startDate = $startDate, endDate = $endDate');
  }

  Future<void> fetchTimetable({bool applyOffset = true}) async {
    print('Fetching timetable data with date offset: $dateOffset...');
    final response = await http.get(Uri.parse('https://party.xenium.rocks/timetable'));

    if (response.statusCode == 200) {
      BeautifulSoup document = BeautifulSoup(response.body);
      List<Bs4Element> days = document.findAll('h2');
      List<Bs4Element> tables = document.findAll('.events');
      eventsData = _processTimetableData(days, tables, applyOffset);
      print('Timetable data processed and loaded');
    } else {
      print('Failed to load timetable with status code: ${response.statusCode}');
    }
  }

  List<Map<String, dynamic>> _processTimetableData(
      List<Bs4Element> days, List<Bs4Element> tables, bool applyOffset) {
    List<Map<String, dynamic>> extractedData = [];
    int minLength = (days.length < tables.length) ? days.length : tables.length;

    if (startDate == null || endDate == null) {
      print('Error: startDate or endDate is null. Please check JSON data.');
      return extractedData;
    }

    Map<String, DateTime> weekdayToDateMap = _generateDateMap(startDate!, endDate!);

    for (int i = 0; i < minLength; i++) {
      final rawDay = days[i].text?.trim();
      DateTime? parsedDate = weekdayToDateMap[rawDay];

      if (parsedDate == null) {
        print('Invalid weekday encountered: $rawDay');
        continue;
      }

      if (applyOffset) {
        parsedDate = parsedDate.add(Duration(days: dateOffset));
      }

      final formattedDate =
          "${DateFormat('EEEE').format(parsedDate)} (${DateFormat('yyyy-MM-dd').format(parsedDate)})";
      String lastKnownTime = '';

      final events = tables[i].findAll('tr').map((eventRow) {
        final time = eventRow.children[0].text?.trim();
        final type = eventRow.children[1].text?.trim() ?? '';
        final description = eventRow.children[2].text?.trim() ?? '';

        final displayTime = (time?.isNotEmpty ?? false) ? time! : lastKnownTime;
        lastKnownTime = displayTime;

        DateTime? eventDateTime;
        try {
          final timeParts = displayTime.split(':');
          eventDateTime = tz.TZDateTime(
            tz.local,
            parsedDate!.year,
            parsedDate.month,
            parsedDate.day,
            int.parse(timeParts[0]), // Godzina
            int.parse(timeParts[1]), // Minuty
          );
          print('Parsed event date and time (local): $eventDateTime');
        } catch (e) {
          print('Error parsing date and time: ${parsedDate!.toIso8601String()} $displayTime');
          return <String, dynamic>{};
        }

        // Schedule notification
        if (eventDateTime.isAfter(tz.TZDateTime.now(tz.local))) {
          try {
            _notificationService.scheduleEventNotification(
              description,
              eventDateTime,
              payload: 'Event: $description at $eventDateTime',
            );
          } catch (e) {
            print('Failed to schedule notification for "$description": $e');
          }
        } else {
          print('Event "$description" is in the past; no notification scheduled.');
        }

        return {
          'time': displayTime,
          'type': type,
          'description': description,
          'icon': getIconForType(type),
          'color': getColorForType(type),
        };
      }).where((event) => event.isNotEmpty).toList();

      extractedData.add({'date': formattedDate, 'events': events});
      print('Processed events for date: $formattedDate');
    }

    print('Processed and applied date offset to timetable data');
    return extractedData;
  }

  Map<String, DateTime> _generateDateMap(DateTime startDate, DateTime endDate) {
    Map<String, DateTime> weekdayToDateMap = {};
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      String weekday = DateFormat('EEEE').format(currentDate);
      weekdayToDateMap.putIfAbsent(weekday, () => currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }

    print('Weekday to date mapping generated: $weekdayToDateMap');
    return weekdayToDateMap;
  }

  Future<void> addEventToCalendar(
      String title, String description, DateTime start, DateTime end,
      {String? location}) async {
    print('Próba dodania wydarzenia do kalendarza:');
    print('Tytuł: $title');
    print('Opis: $description');
    print('Czas rozpoczęcia: $start');
    print('Czas zakończenia: $end');
    nativeCalendarService.addEventToNativeCalendar(
      title: title,
      start: start,
      end: end,
      description: description,
      location: location ?? 'Łódź, Poland',
      allDay: false,
    );
  }
}
