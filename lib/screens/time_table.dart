// TimeTable.dart
import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/theme.dart';
import 'package:demoparty_assistant/data/repositories/time_table_repository.dart';
import 'package:demoparty_assistant/utils/widgets/custom_appbar.dart';
import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';
import 'package:demoparty_assistant/utils/widgets/timeTable/card-event.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({Key? key}) : super(key: key);

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
      appBar: AppBar(title: Text("TimeTable")),
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: AppDrawer(currentPage: "TimeTable"),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: AppDimensions.paddingSmall,
        ),
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
                      padding: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
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
                          SizedBox(height: AppDimensions.paddingSmall),
                          Column(
                            children: (dayData['events'] as List<Map<String, dynamic>>)
                                .map((event) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: AppDimensions.paddingSmall,
                                ),
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
