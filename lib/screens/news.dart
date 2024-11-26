import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/models/news_model.dart';
import 'package:demoparty_assistant/data/repositories/news_repository.dart';
import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';
import 'package:demoparty_assistant/utils/widgets/cards/news_card.dart';
import 'package:demoparty_assistant/utils/widgets/universal/errors/error_display_widget.dart';
import 'package:demoparty_assistant/utils/widgets/universal/errors/error_helper.dart';
import 'package:demoparty_assistant/utils/widgets/universal/loading/loading_widget.dart';
import 'package:get_it/get_it.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  late Future<List<NewsModel>> _newsFuture;
  final NewsRepository _newsRepository = GetIt.I<NewsRepository>();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  /// Fetches news articles with error handling.
  Future<void> _fetchNews({bool forceRefresh = false}) async {
    setState(() => errorMessage = null);

    try {
      _newsFuture = _newsRepository.fetchNews(forceRefresh: forceRefresh);
      await _newsFuture;
    } catch (e) {
      ErrorHelper.handleError(e);
      setState(() => errorMessage = ErrorHelper.getErrorMessage(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Demoparty News"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _fetchNews(forceRefresh: true),
            tooltip: "Refresh News",
          ),
        ],
      ),
      drawer: const AppDrawer(currentPage: "News"),
      body: FutureBuilder<List<NewsModel>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(
              title: "Loading News",
              message: "Fetching the latest news articles. Please wait...",
            );
          }
          if (errorMessage != null) {
            return ErrorDisplayWidget(
              title: "Error Loading News",
              message: errorMessage!,
              onRetry: () => _fetchNews(forceRefresh: true),
            );
          }
          if (snapshot.hasError) {
            return ErrorDisplayWidget(
              title: "Unexpected Error",
              message: ErrorHelper.getErrorMessage(snapshot.error ?? "Unknown error occurred."),
              onRetry: () => _fetchNews(forceRefresh: true),
            );
          }

          final newsList = snapshot.data ?? [];
          if (newsList.isEmpty) {
            return ErrorDisplayWidget(
              title: "No News Available",
              message: "No news articles are currently available. Please check back later.",
              onRetry: () => _fetchNews(forceRefresh: true),
            );
          }

          return ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) => NewsCard(news: newsList[index]),
          );
        },
      ),
    );
  }
}
