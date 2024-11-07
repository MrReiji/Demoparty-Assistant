import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/models/news_model.dart';
import 'package:demoparty_assistant/data/repositories/news_repository.dart';
import 'package:demoparty_assistant/utils/widgets/custom_appbar.dart';
import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';
import 'package:demoparty_assistant/utils/widgets/news/news_card.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  late Future<List<NewsModel>> futureNews;
  final NewsRepository newsRepository = NewsRepository();

  @override
  void initState() {
    super.initState();
    futureNews = newsRepository.fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Demoparty News",
        ),
      ),
      drawer: AppDrawer(currentPage: "News"),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FutureBuilder<List<NewsModel>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load news',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            );
          } else {
            final news = snapshot.data!;
            return ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, index) {
                return NewsCard(news: news[index]);
              },
            );
          }
        },
      ),
    );
  }
}
