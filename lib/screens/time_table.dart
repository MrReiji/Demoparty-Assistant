import 'package:demoparty_assistant/constants/Theme.dart';
import 'package:demoparty_assistant/data/repositories/time_table_repository.dart';
import 'package:demoparty_assistant/data/services/notification_service.dart'; // Dodano
import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';
import 'package:demoparty_assistant/utils/widgets/timeTable/event_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({Key? key}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  late final TimeTableRepository timeTableRepository;
  late final NotificationService notificationService; // Dodano

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService(); // Inicjalizacja NotificationService
    timeTableRepository = TimeTableRepository(notificationService); // Przekazanie obu argumentów
    timeTableRepository.initializeServices();
    timeTableRepository.fetchTimetable().then((_) {
      setState(() {});
      print('Timetable data loaded and UI updated');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("TimeTable")),
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: AppDrawer(currentPage: "TimeTable"),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: AppDimensions.paddingSmall,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timetable Data
            Expanded(
              child: timeTableRepository.eventsData.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: timeTableRepository.eventsData.map((dayData) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppDimensions.paddingMedium),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dayData['date'],
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: theme.colorScheme.onBackground,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: AppDimensions.paddingSmall),
                                Column(
                                  children: (dayData['events']
                                          as List<Map<String, dynamic>>)
                                      .map((event) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: AppDimensions.paddingSmall,
                                      ),
                                      child: EventCard(
                                        time: event['time'],
                                        icon: event['icon'],
                                        title: event['description'],
                                        color: event['color'],
                                        label: event['type'],
                                        addToCalendar: () async {
                                          try {
                                            // Pobierz datę z `dayData['date']`
                                            final dayDateStr = dayData['date']; // E.g., "Monday (2023-10-15)"
                                            // Wyciągnij datę z nawiasów
                                            final dateRegex = RegExp(r'\((\d{4}-\d{2}-\d{2})\)');
                                            final match = dateRegex.firstMatch(dayDateStr);
                                            if (match != null) {
                                              final dateStr = match.group(1);
                                              final parsedDate = DateTime.parse(dateStr!);
                                              final timeStr = event['time']; // E.g., "10:00"

                                              // Połącz datę i godzinę
                                              final timeParts = timeStr.split(':');
                                              final eventDateTime = DateTime(
                                                parsedDate.year,
                                                parsedDate.month,
                                                parsedDate.day,
                                                int.parse(timeParts[0]), // Godzina
                                                int.parse(timeParts[1]), // Minuty
                                              );

                                              // Dodaj wydarzenie do kalendarza
                                              await timeTableRepository.addEventToCalendar(
                                                event['description'],
                                                event['type'],
                                                eventDateTime,
                                                eventDateTime.add(const Duration(hours: 1)), // Załóżmy 1 godzina
                                              );
                                              print('Event "${event['description']}" added to calendar');
                                            } else {
                                              print('Error parsing date from dayData: ${dayData['date']}');
                                            }
                                          } catch (e) {
                                            print('Error during adding event to Google Calendar: $e');
                                          }
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
