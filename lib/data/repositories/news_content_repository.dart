import 'dart:io';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:demoparty_assistant/data/services/cache_service.dart';
import 'package:demoparty_assistant/utils/widgets/universal/errors/error_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class NewsContentRepository {
  final CacheService _cacheService = GetIt.I<CacheService>();

  /// Fetches full content of the article with optional caching and error handling.
  Future<Map<String, dynamic>> fetchContent(String articleUrl,
      {bool forceRefresh = false}) async {
    try {
      // Check cache first if forceRefresh is false
      if (!forceRefresh) {
        final cachedData = _cacheService.getData(articleUrl);
        if (cachedData != null) {
          print("[NewsContentRepository] Returning cached content for $articleUrl");
          return Map<String, dynamic>.from(cachedData);
        }
      }

      // Fetch content from the network
      print("[NewsContentRepository] Fetching content for $articleUrl.");
      final response = await http.get(Uri.parse(articleUrl));

      if (response.statusCode == 200) {
        BeautifulSoup soup = BeautifulSoup(response.body);

        // Extract necessary content from the HTML
        String? publishDate = soup.find('span', class_: 'meta-date')?.text.trim();
        String? contentInnerHtml = soup.find('div', class_: 'post-content')?.outerHtml;
        String? videoUrl = soup.find('iframe')?.attributes['src'];

        final data = {
          'publishDate': publishDate,
          'contentInnerHtml': contentInnerHtml,
          'videoUrl': videoUrl,
        };

        // Cache the fetched content
        await _cacheService.setData(articleUrl, data);

        return data;
      } else {
        throw HttpException(
            "HTTP ${response.statusCode}: Failed to fetch content for $articleUrl");
      }
    } catch (e) {
      // Handle and log the error
      ErrorHelper.handleError(e);
      throw Exception(ErrorHelper.getErrorMessage(e));
    }
  }
}
