class NewsModel {
  final String title;
  final String content;
  final String fullContent;
  final String imageUrl;
  final String articleUrl;
  final List<String> categories; // Lista kategorii

  NewsModel({
    required this.title,
    required this.content,
    required this.fullContent,
    required this.imageUrl,
    required this.articleUrl,
    required this.categories,
  });
}
