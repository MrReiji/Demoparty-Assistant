import 'package:demoparty_assistant/utils/widgets/cards/event_card.dart';
import 'package:flutter/material.dart';
import 'package:demoparty_assistant/utils/widgets/universal/errors/error_display_widget.dart';
import 'package:demoparty_assistant/utils/widgets/universal/errors/error_helper.dart';
import 'package:demoparty_assistant/utils/widgets/universal/loading/loading_widget.dart';
import 'package:demoparty_assistant/data/repositories/time_table_repository.dart';
import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';
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
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _repository = GetIt.instance<TimeTableRepository>();
    _dataFuture = _initializeData();
  }

  /// Initializes timetable data with error handling.
  Future<void> _initializeData({bool forceRefresh = false}) async {
    try {
      setState(() => errorMessage = null);
      await _repository.loadOnboardingDates();
      await _repository.fetchTimetable(forceRefresh: forceRefresh);
      _generateWidgets();
    } catch (e) {
      ErrorHelper.handleError(e);
      setState(() => errorMessage = ErrorHelper.getErrorMessage(e));
    }
  }

  /// Generates widgets for timetable data.
  void _generateWidgets() {
    final eventsData = _repository.eventsData;
    setState(() {
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
    });
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _dataFuture = _initializeData(forceRefresh: true);
              });
            },
            tooltip: "Refresh Timetable",
          ),
        ],
      ),
      drawer: AppDrawer(currentPage: "TimeTable"),
      body: FutureBuilder<void>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(
              title: "Loading Timetable",
              message: "Please wait while we fetch the latest timetable data.",
            );
          } else if (errorMessage != null) {
            return ErrorDisplayWidget(
              title: "Error Loading Timetable",
              message: errorMessage!,
              onRetry: () => setState(() {
                _dataFuture = _initializeData(forceRefresh: true);
              }),
            );
          } else if (_timeTableWidgets.isEmpty) {
            return ErrorDisplayWidget(
              title: "No Timetable Data",
              message: "Currently, there are no timetable events available. Please check back later.",
            );
          }

          return _buildTimeTableContent();
        },
      ),
    );
  }

  Widget _buildTimeTableContent() {
    return RefreshIndicator(
      onRefresh: () => _initializeData(forceRefresh: true),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ListView(
          children: _timeTableWidgets,
        ),
      ),
    );
  }
}
