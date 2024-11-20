import 'package:flutter/material.dart';
import 'package:demoparty_assistant/data/repositories/time_table_repository.dart';
import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';
import 'package:demoparty_assistant/utils/widgets/timeTable/event_card.dart';
import 'package:get_it/get_it.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({Key? key}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> with AutomaticKeepAliveClientMixin {
  late final TimeTableRepository _repository;
  late Future<void> _dataFuture;

  @override
  void initState() {
    super.initState();
    _repository = GetIt.instance<TimeTableRepository>();
    _dataFuture = _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      print('[TimeTable] Loading onboarding dates...');
      await _repository.loadOnboardingDates();
      print('[TimeTable] Loading timetable data...');
      await _repository.fetchTimetable();

      print('[TimeTable] Events data loaded:');
      for (var day in _repository.eventsData) {
        print("[TimeTable] Day: ${day['date']}, Events count: ${(day['events'] as List?)?.length ?? 0}");
      }
    } catch (e) {
      print('[TimeTable] Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load timetable: $e')),
        );
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("TimeTable"),
      ),
      drawer: AppDrawer(currentPage: "TimeTable"),
      body: FutureBuilder<void>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading timetable: ${snapshot.error}',
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error),
              ),
            );
          }

          return _buildTimeTableContent(theme);
        },
      ),
    );
  }

  Widget _buildTimeTableContent(ThemeData theme) {
    final eventsData = _repository.eventsData;

    print("[TimeTable] Total days available: ${eventsData.length}");

    if (eventsData.isEmpty) {
      print('[TimeTable] No events data available.');
      return const Center(
        child: Text('No timetable data available.'),
      );
    }

    // Optymalizacja: użycie ListView.builder zamiast statycznej listy widgetów
    return ListView.builder(
      itemCount: eventsData.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        final dayData = eventsData[index];
        print("[TimeTable] Rendering day: ${dayData['date']}, Events count: ${(dayData['events'] as List?)?.length ?? 0}");
        return _buildDayData(dayData, theme);
      },
    );
  }

  Widget _buildDayData(Map<String, dynamic> dayData, ThemeData theme) {
    print("[TimeTable] Processing day: ${dayData['date']}");

    final events = (dayData['events'] as List?)?.map((e) {
      if (e is Map<dynamic, dynamic>) {
        return Map<String, dynamic>.from(e);
      }
      return e as Map<String, dynamic>;
    }).toList() ?? [];

    if (events.isEmpty) {
      print("[TimeTable] No events found for day: ${dayData['date']}");
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'No events available for ${dayData['date'] ?? 'this day'}.',
          style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dayData['date'] ?? '',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            itemBuilder: (context, eventIndex) {
              final event = events[eventIndex];
              print("[TimeTable] Event details: $event");
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: EventCard(
                  time: event['time'] ?? '',
                  icon: IconData(event['icon'] ?? 0xe3c9, fontFamily: 'MaterialIcons'),
                  title: event['description'] ?? '',
                  color: Color(event['color'] ?? 0xFFCCCCCC),
                  label: event['type'] ?? '',
                  addToCalendar: () => _repository.addEventToCalendar(
                    dayData['date'] ?? '',
                    event['time'] ?? '',
                    event['description'] ?? '',
                    event['type'] ?? '',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
