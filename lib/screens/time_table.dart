import 'package:demoparty_assistant/data/repositories/time_table_repository.dart';
import 'package:demoparty_assistant/utils/widgets/custom_appbar.dart';
import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';
import 'package:demoparty_assistant/utils/widgets/timeTable/card-event.dart';
import 'package:flutter/material.dart';

class TimeTable extends StatefulWidget {
  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  final TimeTableRepository timeTableRepository = TimeTableRepository();

  @override
  void initState() {
    super.initState();
    timeTableRepository.fetchTimetable().then((_) {
      setState(() {}); // Odświeżenie widoku po załadowaniu danych
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: "TimeTable"),
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: AppDrawer(currentPage: "TimeTable"),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: timeTableRepository.eventsData.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: timeTableRepository.eventsData.map((dayData) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
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
                          const SizedBox(height: 8.0),
                          Column(
                            children: (dayData['events'] as List<Map<String, dynamic>>)
                                .map((event) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: EventCard(
                                  time: event['time'],
                                  icon: event['icon'],
                                  title: event['description'],
                                  color: event['color'],
                                  label: event['type'],
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
    );
  }
}
