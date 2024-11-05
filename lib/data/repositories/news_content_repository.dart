import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';

class NewsContentRepository {
  /// Fetches the content details of a news article from the given URL.
  Future<Map<String, dynamic>> fetchContent(String articleUrl) async {
    final response = await http.get(Uri.parse(articleUrl));
    if (response.statusCode == 200) {
      BeautifulSoup soup = BeautifulSoup(response.body);

      // Fetch and trim publish date if present
      String? publishDate;
      var dateElement = soup.findAll('span', class_: 'meta-date').firstWhere(
        (element) => !(element.attributes['class']?.contains('rich-snippet-hidden') ?? false),
      );
      if (dateElement != null && dateElement.text.trim().isNotEmpty) {
        publishDate = dateElement.text.trim();
      }

      // Fetch video URL if available
      var videoIframe = soup.find('iframe');
      String? videoUrl = videoIframe?.attributes['src'];

      // Fetch the main content section of the article
      var contentInner = soup.find('div', class_: 'post-content');
      return {
        'publishDate': publishDate,
        'contentInner': contentInner,
        'videoUrl': videoUrl,
      };
    } else {
      throw Exception("Failed to fetch content");
    }
  }

  /// Replaces protected emails with a default email address
  String replaceProtectedEmails(String text) {
    return text.replaceAll(RegExp(r'\[email[\s\u200B]*protected\]'), "xenium@xenium.rocks");
  }
}
