import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/theme.dart';
import 'package:demoparty_assistant/data/repositories/news_content_repository.dart';
import 'package:demoparty_assistant/data/services/news_content_service.dart';

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
  final NewsContentService _newsContentService =
      NewsContentService(NewsContentRepository());
  List<Widget> _contentWidgets = [];
  String? _publishDate;

  @override
  void initState() {
    super.initState();
    _fetchFullContent();
  }

  Future<void> _fetchFullContent() async {
    try {
      final data =
          await _newsContentService.fetchFullContent(widget.articleUrl);

      setState(() {
        _publishDate = data['publishDate'];
        _contentWidgets = data['contentWidgets'];
      });
    } catch (e) {
      setState(() {
        _contentWidgets = [Text("Failed to load content")];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
      ),),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.image.isNotEmpty)
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadius),
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              SizedBox(height: AppDimensions.paddingMedium),
              Text(
                widget.title,
                style: theme.textTheme.headlineLarge,
              ),
              if (_publishDate != null)
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
                  child: Text(
                    "Published on: $_publishDate",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                    ),
                  ),
                ),
              Divider(
                color: theme.dividerColor,
                thickness: theme.dividerTheme.thickness,
              ),
              ..._contentWidgets,
            ],
          ),
        ),
      ),
    );
  }
}
