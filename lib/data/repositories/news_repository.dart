import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:demoparty_assistant/constants/models/news_model.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  /// Fetches a list of news articles from available pages.
  Future<List<NewsModel>> fetchNews() async {
    final List<NewsModel> newsList = [];
    int page = 1;

    while (true) {
      final url = 'https://2024.xenium.rocks/category/wiesci/page/$page/';
      final response = await http.get(Uri.parse(url));

      // Break the loop if the page doesn't exist (e.g., 404 status code)
      if (response.statusCode != 200) {
        break;
      }

      BeautifulSoup soup = BeautifulSoup(response.body);
      var articles = soup.findAll('article', class_: 'masonry-blog-item');

      // If there are no articles found, stop processing further pages
      if (articles.isEmpty) {
        break;
      }

      for (var article in articles) {
        var title = article.find('h3', class_: 'title')?.text?.trim() ?? 'No title';
        var articleUrl = article.find('a', class_: 'entire-meta-link')?.attributes['href'] ?? '';
        var imageUrl = article.find('span', class_: 'post-featured-img')?.find('img')?.attributes['src'] ?? '';
        var categoryElements = article.findAll('span', class_: 'meta-category').expand((span) {
          return span.findAll('a').map((a) => a.text.trim());
        }).toList();
        var content = article.find('p', class_: 'excerpt')?.text ?? '';

        newsList.add(NewsModel(
          title: title,
          content: content,
          fullContent: '', // Full content will be loaded in NewsDetailScreen
          imageUrl: imageUrl,
          articleUrl: articleUrl,
          categories: categoryElements,
        ));
      }

      page++; // Increment the page number for the next iteration
    }

    return newsList;
  }
}
