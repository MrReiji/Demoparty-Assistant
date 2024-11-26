import 'dart:convert';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:demoparty_assistant/constants/models/news_model.dart';
import 'package:demoparty_assistant/data/services/cache_service.dart';
import 'package:demoparty_assistant/data/services/settings_service.dart';
import 'package:demoparty_assistant/utils/widgets/universal/errors/error_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  final CacheService _cacheService = GetIt.I<CacheService>();
  final SettingsService _settingsService = GetIt.I<SettingsService>();

  /// Fetches a list of news articles, with optional cache bypass and error handling.
  Future<List<NewsModel>> fetchNews({bool forceRefresh = false}) async {
    const cacheKey = 'news_list';
    final isCacheEnabled = await _settingsService.isCacheEnabled();

    try {
      // Attempt to load from cache if enabled and not forcing refresh.
      if (isCacheEnabled && !forceRefresh) {
        final cachedData = _cacheService.getData(cacheKey);
        if (cachedData != null) {
          print("[NewsRepository] Returning cached news.");
          return (cachedData as List).map((json) => NewsModel.fromJson(json)).toList();
        }
      }

      print("[NewsRepository] Fetching news from remote source.");
      final List<NewsModel> newsList = [];
      int page = 1;

      while (true) {
        final url = 'https://2024.xenium.rocks/category/wiesci/page/$page/';
        final response = await http.get(Uri.parse(url));

        if (response.statusCode != 200) break;

        BeautifulSoup soup = BeautifulSoup(response.body);
        var articles = soup.findAll('article', class_: 'masonry-blog-item');

        if (articles.isEmpty) break;

        for (var article in articles) {
          final title = article.find('h3', class_: 'title')?.text?.trim() ?? 'No title';
          final articleUrl = article.find('a', class_: 'entire-meta-link')?.attributes['href'] ?? '';
          final imageUrl = article.find('span', class_: 'post-featured-img')?.find('img')?.attributes['src'] ?? '';
          var categories = article
              .findAll('span', class_: 'meta-category')
              .expand((span) => span.findAll('a').map((a) => a.text.trim()))
              .toList();
          final content = article.find('p', class_: 'excerpt')?.text ?? '';

          newsList.add(NewsModel(
            title: title,
            content: content,
            fullContent: '',
            imageUrl: imageUrl,
            articleUrl: articleUrl,
            categories: categories,
          ));
        }

        page++;
      }

      // Cache the fetched data if enabled.
      if (isCacheEnabled) {
        await _cacheService.setData(cacheKey, newsList.map((news) => news.toJson()).toList());
      }

      return newsList;
    } catch (e) {
      ErrorHelper.handleError(e);
      throw Exception(ErrorHelper.getErrorMessage(e));
    }
  }
}
