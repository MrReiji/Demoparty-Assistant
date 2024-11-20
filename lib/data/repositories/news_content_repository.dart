import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:demoparty_assistant/data/services/cache_service.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class NewsContentRepository {
  final CacheService _cacheService = GetIt.I<CacheService>();

  /// Fetches the content details of a news article.
  ///
  /// - `articleUrl`: The URL of the article to fetch.
  /// - `forceRefresh`: If true, bypasses the cache and fetches fresh data.
  /// - Returns: A map containing article details such as publish date, main content, and video URL.
  Future<Map<String, dynamic>> fetchContent(String articleUrl, {bool forceRefresh = false}) async {
    final cachedData = _cacheService.get(articleUrl);

    if (!forceRefresh && cachedData != null) {
      print("[NewsContentRepository] Returning cached content for $articleUrl");
      return cachedData;
    }

    print("[NewsContentRepository] Fetching content for $articleUrl from network.");
    final response = await http.get(Uri.parse(articleUrl));
    if (response.statusCode == 200) {
      BeautifulSoup soup = BeautifulSoup(response.body);

      String? publishDate = soup.find('span', class_: 'meta-date')?.text.trim();
      var contentInner = soup.find('div', class_: 'post-content');
      String? videoUrl = soup.find('iframe')?.attributes['src'];

      final data = {
        'publishDate': publishDate,
        'contentInner': contentInner,
        'videoUrl': videoUrl,
      };

      // Cache the fetched content
      await _cacheService.set(articleUrl, data, 3600);
      return data;
    } else {
      throw Exception("Failed to fetch content for $articleUrl");
    }
  }

  /// Replaces protected emails with a default email address
  String replaceProtectedEmails(String text) {
    return text.replaceAll(RegExp(r'\[email[\s\u200B]*protected\]'), "xenium@xenium.rocks");
  }
}
