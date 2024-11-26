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
  List<Map<String, dynamic>> _dayData = [];
  String? errorMessage;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repository = GetIt.instance<TimeTableRepository>();
    _dataFuture = _initializeData();
    _searchController.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Initializes timetable data with error handling.
  Future<void> _initializeData({bool forceRefresh = false}) async {
    try {
      setState(() => errorMessage = null);
      await _repository.loadOnboardingDates();
      await _repository.fetchTimetable(forceRefresh: forceRefresh);
      _dayData = List.from(_repository.eventsData); // Copy the original data.
      setState(() {}); // Refresh the UI after initialization.
    } catch (e) {
      ErrorHelper.handleError(e);
      setState(() => errorMessage = ErrorHelper.getErrorMessage(e));
    }
  }

  /// Applies a search filter to the data.
  void _applyFilter() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        // If the search field is empty, reset to original data.
        _dayData = List.from(_repository.eventsData);
      } else {
        // Filter each day's events based on the search query.
        _dayData = _repository.eventsData.map((day) {
          final dayDate = day['date'] ?? 'Unknown date';
          final filteredEvents = (day['events'] as List?)
              ?.where((event) => event.values.any((value) =>
                  value.toString().toLowerCase().contains(query)))
              .toList();
          return {
            'date': dayDate,
            'events': filteredEvents ?? [],
          };
        }).toList();
      }
    });
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
              // Reset search field and reload data.
              _searchController.clear();
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
          }

          return _buildTimeTableContent(theme);
        },
      ),
    );
  }

  Widget _buildTimeTableContent(ThemeData theme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              // Reset search field and reload data.
              _searchController.clear();
              setState(() {
                _dataFuture = _initializeData(forceRefresh: true);
              });
              await _dataFuture;
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: _dayData.length,
              itemBuilder: (context, index) {
                final day = _dayData[index];
                final dayDate = day['date'] ?? 'Unknown date';
                final events = day['events'] as List? ?? [];
                return _buildDayDataWidget(dayDate, events);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayDataWidget(String dayDate, List events) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wyświetlenie daty dnia.
          Text(
            dayDate,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          // Jeśli brak wydarzeń, pokazujemy estetyczny komunikat.
          if (events.isEmpty)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    color: theme.colorScheme.primary.withOpacity(0.8),
                    size: 28,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    "No events scheduled for this day",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          // Jeśli wydarzenia są, pokazujemy listę.
          else
            Column(
              children: events.map<Widget>((event) {
                final eventMap = Map<String, dynamic>.from(event);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: EventCard(
                    time: eventMap['time'] ?? '',
                    icon: IconData(eventMap['icon'] ?? 0xe3c9, fontFamily: eventMap['fontFamily'] ?? 'MaterialIcons'),
                    title: eventMap['description'] ?? '',
                    color: Color(eventMap['color'] ?? 0xFFCCCCCC),
                    label: eventMap['type'] ?? '',
                    addToCalendar: () => _repository.addEventToCalendar(
                      dayDate,
                      eventMap['time'] ?? '',
                      eventMap['description'] ?? '',
                      eventMap['type'] ?? '',
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
