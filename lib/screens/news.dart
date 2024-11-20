import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/models/news_model.dart';
import 'package:demoparty_assistant/data/repositories/news_repository.dart';
import 'package:get_it/get_it.dart';

class News extends StatelessWidget {
  final NewsRepository _newsRepository = GetIt.instance<NewsRepository>();

  News({Key? key}) : super(key: key);

  Future<List<NewsModel>> _fetchNews() => _newsRepository.fetchNews();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("News")),
      body: FutureBuilder<List<NewsModel>>(
        future: _fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Failed to load news: ${snapshot.error}"));
          }

          final news = snapshot.data ?? [];
          return ListView.builder(
            itemCount: news.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(news[index].title),
              subtitle: Text(news[index].content),
            ),
          );
        },
      ),
    );
  }
}
