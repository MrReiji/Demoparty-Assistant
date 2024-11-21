import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/models/news_model.dart';
import 'package:demoparty_assistant/data/repositories/news_repository.dart';
import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';
import 'package:demoparty_assistant/utils/widgets/news/news_card.dart';
import 'package:get_it/get_it.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  late Future<List<NewsModel>> _newsFuture;
  final NewsRepository _newsRepository = GetIt.I<NewsRepository>();

  @override
  void initState() {
    super.initState();
    _newsFuture = _newsRepository.fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Demoparty News"),
      ),
      drawer: const AppDrawer(currentPage: "News"),
      body: FutureBuilder<List<NewsModel>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load news',
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error),
              ),
            );
          }

          final newsList = snapshot.data ?? [];
          return ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) => NewsCard(news: newsList[index]),
          );
        },
      ),
    );
  }
}
