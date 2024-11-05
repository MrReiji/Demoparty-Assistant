import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:demoparty_assistant/utils/functions/getColorForType.dart';
import 'package:demoparty_assistant/utils/functions/getIconForType.dart';

class TimeTableRepository {
  List<Map<String, dynamic>> eventsData = [];

  Future<void> fetchTimetable() async {
    final response = await http.get(Uri.parse('https://party.xenium.rocks/timetable'));

    if (response.statusCode == 200) {
      BeautifulSoup document = BeautifulSoup(response.body);
      List<Bs4Element> days = document.findAll('h2');
      List<Bs4Element> tables = document.findAll('.events');

      eventsData = _processTimetableData(days, tables);
    } else {
      print('Failed to load timetable');
    }
  }

  List<Map<String, dynamic>> _processTimetableData(
      List<Bs4Element> days, List<Bs4Element> tables) {
    List<Map<String, dynamic>> extractedData = [];
    int minLength = (days.length < tables.length) ? days.length : tables.length;

    for (int i = 0; i < minLength; i++) {
      final day = days[i].text?.trim();
      String lastKnownTime = '';

      final events = tables[i].findAll('tr').map((eventRow) {
        final time = eventRow.children[0].text?.trim();
        final type = eventRow.children[1].text?.trim() ?? '';
        final description = eventRow.children[2].text?.trim() ?? '';

        final displayTime = (time?.isNotEmpty ?? false) ? time! : lastKnownTime;
        lastKnownTime = displayTime;

        return {
          'time': displayTime,
          'type': type,
          'description': description,
          'icon': getIconForType(type),
          'color': getColorForType(type),
        };
      }).toList();

      extractedData.add({'date': day, 'events': events});
    }

    return extractedData;
  }
}
