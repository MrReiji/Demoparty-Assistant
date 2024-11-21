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
  List<Widget> _timeTableWidgets = [];

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
      print('[TimeTable] Generating widgets...');
      _generateWidgets();
    } catch (e) {
      print('[TimeTable] Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load timetable: $e')),
        );
      }
    }
  }

  void _generateWidgets() {
    if (_timeTableWidgets.isNotEmpty) return; // Avoid regenerating widgets if already present

    final eventsData = _repository.eventsData;
    print("[TimeTable] Generating widgets for ${eventsData.length} days...");

    _timeTableWidgets = eventsData.map((dayData) {
      final dayDate = dayData['date'] ?? 'Unknown date';
      final events = (dayData['events'] as List?)?.map((e) {
        if (e is Map<dynamic, dynamic>) {
          return Map<String, dynamic>.from(e);
        }
        return e as Map<String, dynamic>;
      }).toList() ?? [];

      return _buildDayDataWidget(dayDate, events);
    }).toList();
  }

  Widget _buildDayDataWidget(String dayDate, List<Map<String, dynamic>> events) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dayDate,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Column(
            children: events.map((event) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: EventCard(
                  time: event['time'] ?? '',
                  icon: IconData(event['icon'] ?? 0xe3c9, fontFamily: event['fontFamily'] ?? 'MaterialIcons'),
                  title: event['description'] ?? '',
                  color: Color(event['color'] ?? 0xFFCCCCCC),
                  label: event['type'] ?? '',
                  addToCalendar: () => _repository.addEventToCalendar(
                    dayDate,
                    event['time'] ?? '',
                    event['description'] ?? '',
                    event['type'] ?? '',
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
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

          return _buildTimeTableContent();
        },
      ),
    );
  }

  Widget _buildTimeTableContent() {
    if (_timeTableWidgets.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('No timetable data available.'),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => setState(() {
                _dataFuture = _initializeData();
              }),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _initializeData,
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: _timeTableWidgets,
      ),
    );
  }
}
