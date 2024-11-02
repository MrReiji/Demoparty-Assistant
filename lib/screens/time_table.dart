import 'package:demoparty_assistant/utils/widgets/drawer.dart';
import 'package:demoparty_assistant/utils/widgets/card-event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TimeTable extends StatefulWidget {
  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  List<Map<String, dynamic>> eventsData = [];

  @override
  void initState() {
    super.initState();
    fetchTimetable();
  }

  Future<void> fetchTimetable() async {
    final response = await http.get(Uri.parse('https://party.xenium.rocks/timetable'));

    if (response.statusCode == 200) {
      BeautifulSoup document = BeautifulSoup(response.body);
      List<Bs4Element> days = document.findAll('h2');
      List<Bs4Element> tables = document.findAll('.events');

      List<Map<String, dynamic>> extractedData = [];
      int minLength = (days.length < tables.length) ? days.length : tables.length;

      for (int i = 0; i < minLength; i++) {
        final day = days[i].text?.trim();
        final events = tables[i].findAll('tr').map((eventRow) {
          final time = eventRow.children[0].text?.trim() ?? '';
          final type = eventRow.children[1].text?.trim() ?? '';
          final description = eventRow.children[2].text?.trim() ?? '';

          return {
            'time': time,
            'type': type,
            'description': description,
            'icon': getIconForType(type),
            'color': getColorForType(type),
          };
        }).toList();

        extractedData.add({
          'date': day,
          'events': events,
        });
      }

      setState(() {
        eventsData = extractedData;
      });
    } else {
      print('Failed to load timetable');
    }
  }

  IconData getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'event':
        return FontAwesomeIcons.calendarDay;
      case 'seminar':
        return FontAwesomeIcons.chalkboardUser;
      case 'concert':
        return FontAwesomeIcons.music;
      case 'deadline':
        return FontAwesomeIcons.exclamationTriangle;
      case 'compo':
        return FontAwesomeIcons.laptopCode;
      default:
        return FontAwesomeIcons.infoCircle;
    }
  }

  Color getColorForType(String type) {
    final theme = Theme.of(context);
    switch (type.toLowerCase()) {
      case 'event':
        return theme.colorScheme.primary;
      case 'seminar':
        return theme.colorScheme.secondary;
      case 'concert':
        return theme.colorScheme.error;
      case 'deadline':
        return theme.colorScheme.error.withOpacity(0.8); // Przykładowe użycie ostrzeżenia
      case 'compo':
        return theme.colorScheme.secondaryContainer ?? Colors.teal;
      default:
        return theme.colorScheme.onBackground.withOpacity(0.6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("TimeTable"),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: AppDrawer(currentPage: "TimeTable"),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: eventsData.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: eventsData.map((dayData) {
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
                            children: (dayData['events'] as List<Map<String, dynamic>>).map((event) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: EventCard(
                                  time: event['time'],
                                  icon: event['icon'],
                                  title: event['description'],
                                  author: 'Organizing Committee',
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
