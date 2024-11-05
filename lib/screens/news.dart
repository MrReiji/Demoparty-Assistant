import 'package:demoparty_assistant/constants/models/news_model.dart';
import 'package:demoparty_assistant/data/repositories/news_repository.dart';
import 'package:demoparty_assistant/utils/widgets/custom_appbar.dart';
import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';
import 'package:demoparty_assistant/utils/widgets/news/news_card.dart';
import 'package:flutter/material.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  late Future<List<NewsModel>> futureNews;
  final NewsRepository newsRepository = NewsRepository(); // Create an instance of NewsRepository

  @override
  void initState() {
    super.initState();
    futureNews = newsRepository.fetchNews(); // Use the repository method
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Demoparty News"),
      drawer: AppDrawer(currentPage: "News"),
      body: FutureBuilder<List<NewsModel>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load news'));
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
