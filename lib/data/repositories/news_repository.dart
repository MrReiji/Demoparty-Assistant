import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:demoparty_assistant/constants/models/news_model.dart';
import 'package:demoparty_assistant/data/services/cache_service.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  final CacheService _cacheService;

  NewsRepository(this._cacheService);

  /// Fetches a list of news articles, using cache if available.
  Future<List<NewsModel>> fetchNews() async {
    const cacheKey = 'news_list';

    // Check cache
    final cachedData = _cacheService.get(cacheKey);
    if (cachedData != null) {
      print("[NewsRepository] Returning cached news.");
      return (cachedData as List).map((json) => NewsModel.fromJson(json)).toList();
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
        final categories = article.findAll('span', class_: 'meta-category').map((e) => e.text.trim()).toList();
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

    // Cache results
    _cacheService.set(cacheKey, newsList.map((news) => news.toJson()).toList());

    return newsList;
  }
}
