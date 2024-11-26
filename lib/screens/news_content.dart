import 'package:flutter/material.dart';
import 'package:demoparty_assistant/data/services/news_content_service.dart';
import 'package:demoparty_assistant/utils/widgets/universal/errors/error_display_widget.dart';
import 'package:demoparty_assistant/utils/widgets/universal/errors/error_helper.dart';
import 'package:demoparty_assistant/utils/widgets/universal/loading/loading_widget.dart';
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
  State<NewsContentScreen> createState() => _NewsContentScreenState();
}

class _NewsContentScreenState extends State<NewsContentScreen> {
  final NewsContentService _newsContentService = GetIt.I<NewsContentService>();
  List<Widget> _contentWidgets = [];
  String? _publishDate;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchContent();
  }

  /// Fetches the full content of the article with error handling.
  Future<void> _fetchContent({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _newsContentService.fetchFullContent(
        widget.articleUrl,
        forceRefresh: forceRefresh,
      );
      setState(() {
        _publishDate = data['publishDate'];
        _contentWidgets = data['contentWidgets'];
      });
    } catch (e) {
      ErrorHelper.handleError(e);
      setState(() {
        _errorMessage = ErrorHelper.getErrorMessage(e);
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _fetchContent(forceRefresh: true),
            tooltip: "Refresh Content",
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget(
              title: "Loading Content",
              message: "Fetching the full article content. Please wait...",
            )
          : _errorMessage != null
              ? ErrorDisplayWidget(
                  title: "Error Loading Content",
                  message: _errorMessage!,
                  onRetry: () => _fetchContent(forceRefresh: true),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.image.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            widget.image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.broken_image,
                              size: 100,
                              color: theme.colorScheme.error,
                            ),
                          ),
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
                      if (_contentWidgets.isNotEmpty)
                        ..._contentWidgets
                      else
                        const Text("No content available."),
                    ],
                  ),
                ),
    );
  }
}
