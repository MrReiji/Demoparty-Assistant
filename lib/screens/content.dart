import 'package:flutter/material.dart';
import 'package:demoparty_assistant/data/services/content_service.dart';
import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';
import 'package:demoparty_assistant/constants/theme.dart';

class ContentScreen extends StatefulWidget {
  final String url;
  final String title;
  final String currentPage;

  const ContentScreen({
    required this.url,
    required this.title,
    required this.currentPage,
    Key? key,
  }) : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late Future<List<Widget>> _contentFuture;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  void _loadContent({bool forceRefresh = false}) {
    _contentFuture = ContentService().fetchContent(widget.url, forceRefresh: forceRefresh);
  }

  Future<void> _refreshContent() async {
    _loadContent(forceRefresh: true);
    await _contentFuture; // Ensure new data is fetched
    setState(() {}); // Update the UI with the new data
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: theme.textTheme.titleLarge,
        ),
      ),
      drawer: AppDrawer(currentPage: widget.currentPage),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _refreshContent,
        child: FutureBuilder<List<Widget>>(
          future: _contentFuture,
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
                  'Error loading content',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              List<Widget> contentWidgets = snapshot.data!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: contentWidgets,
                ),
              );
            } else {
              return Center(
                child: Text(
                  'No content to display',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
