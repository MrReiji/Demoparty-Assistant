import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:http/http.dart' as http;

/// A service responsible for fetching live and archived streams.
class StreamsService {
  /// Fetches live stream data from the provided URL.
  static Future<Map<String, String>?> fetchLiveStream() async {
    try {
      final response = await http.get(Uri.parse('https://scenesat.com/video/1'));

      if (response.statusCode == 200) {
        final BeautifulSoup soup = BeautifulSoup(response.body);
        print('Fetched live stream data');

        // Extract metadata
        final title = soup.find('meta',
            attrs: {'property': 'og:title'})?.attributes['content'];
        final description = soup.find('meta',
            attrs: {'property': 'og:description'})?.attributes['content'];
        final videoElement = soup.find('video', class_: 'fp-engine');
        final videoUrl = videoElement?.attributes['src'];
        print('Video URL: $videoUrl');
        if (title != null && description != null && videoUrl != null) {
          final resolvedUrl =
              videoUrl.startsWith('blob:') ? videoUrl.substring(5) : videoUrl;
          print('Live stream found: $title');
          return {
            'title': title,
            'description': description,
            'url': resolvedUrl,
          };
        }
      }
    } catch (e) {
      print('Error fetching live stream: $e');
    }
    return null;
  }

  /// Fetches archived stream data from the provided URL.
  static Future<List<Map<String, String>>> fetchArchiveStreams() async {
  List<Map<String, String>> streams = [];
  try {
    final response =
        await http.get(Uri.parse('https://scenesat.com/videoarchive'));

    if (response.statusCode == 200) {
      final BeautifulSoup soup = BeautifulSoup(response.body);
      final streamElements = soup.findAll('div', class_: 'row');

      for (var element in streamElements) {
        final titleElement = element.find('dd');
        final dateElement = element.find('dt');
        final urlElement =
            element.find('span', class_: 'playersrc')?.attributes['data-url'];

        if (titleElement != null &&
            dateElement != null &&
            urlElement != null) {
          final stream = {
            'title': titleElement.text.trim(),
            'date': dateElement.text.split('[').first.trim(),
            'duration':
                dateElement.text.split('[').last.replaceAll(']', '').trim(),
            'url': urlElement,
          };

          // Check for duplicates in the list
          if (!streams.any((s) =>
              s['title']?.toLowerCase() == stream['title']?.toLowerCase() &&
              s['url'] == stream['url'])) {
            streams.add(stream);
            print("Added new archived stream: $stream");
          }
        }
      }
    }
  } catch (e) {
    print('Error fetching archive streams: $e');
  }
  return streams;
}
}
