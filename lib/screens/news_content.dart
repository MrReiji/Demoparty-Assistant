import 'package:flutter/material.dart';
import 'package:demoparty_assistant/data/services/news_content_service.dart';
import 'package:get_it/get_it.dart';

class NewsContentScreen extends StatefulWidget {
  final String title;
  final String image;
  final String articleUrl;

  const NewsContentScreen({
    required this.title,
    required this.image,
    required this.articleUrl,
    Key? key,
  }) : super(key: key);

  @override
  _NewsContentScreenState createState() => _NewsContentScreenState();
}

class _NewsContentScreenState extends State<NewsContentScreen> {
  final NewsContentService _newsContentService = GetIt.I<NewsContentService>();

  List<Widget> _contentWidgets = [];
  String? _publishDate;

  @override
  void initState() {
    super.initState();
    _fetchFullContent();
  }

  /// Fetches the full content of the article, with cache support.
  Future<void> _fetchFullContent() async {
    try {
      final data = await _newsContentService.fetchFullContent(widget.articleUrl);
      setState(() {
        _publishDate = data['publishDate'];
        _contentWidgets = data['contentWidgets'];
      });
    } catch (e) {
      setState(() {
        _contentWidgets = [const Text("Failed to load content")];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.image.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(widget.image, fit: BoxFit.cover),
                ),
              const SizedBox(height: 16.0),
              Text(widget.title, style: theme.textTheme.headlineMedium),
              if (_publishDate != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Published on: $_publishDate",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              const Divider(),
              ..._contentWidgets,
            ],
          ),
        ),
      ),
    );
  }
}
