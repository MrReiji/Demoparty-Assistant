import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:demoparty_assistant/constants/models/news_model.dart';
import 'package:http/http.dart' as http;

Future<List<NewsModel>> fetchNews() async {
  final List<NewsModel> newsList = [];
  final urls = [
    'https://2024.xenium.rocks/category/wiesci/',
    'https://2024.xenium.rocks/category/wiesci/page/2/'
  ];

  for (var url in urls) {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Initialize BeautifulSoup object
      BeautifulSoup soup = BeautifulSoup(response.body);

      // Znajdź wszystkie artykuły na stronie
      var articles = soup.findAll('article', class_: 'masonry-blog-item'); 

      for (var article in articles) {
        // Tytuł artykułu
        var title = article.find('h3', class_: 'title')?.text?.trim() ?? 'No title';

        // Link do pełnej wersji artykułu
        var articleUrl = article.find('a', class_: 'entire-meta-link')?.attributes['href'] ?? '';

        // Obraz artykułu
        var imageUrl = article.find('span', class_: 'post-featured-img')?.find('img')?.attributes['src'] ?? '';

        // Pobieranie wszystkich kategorii jako lista z linków <a> wewnątrz <span class="meta-category">
        var categoryElements = article.findAll('span', class_: 'meta-category').expand((span) {
          return span.findAll('a').map((a) => a.text.trim());
        }).toList();

        // Krótka treść lub wprowadzenie, jeśli dostępne
        var content = article.find('p', class_: 'excerpt')?.text ?? '';

        newsList.add(NewsModel(
          title: title,
          content: content,
          fullContent: '', // pełna treść załadujemy w NewsDetailScreen
          imageUrl: imageUrl,
          articleUrl: articleUrl,
          categories: categoryElements, // Zapisujemy pełną listę kategorii
        ));
      }
    } else {
      throw Exception('Failed to load news');
    }
  }
  return newsList;
}
