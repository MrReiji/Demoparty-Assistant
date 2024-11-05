import 'package:demoparty_assistant/data/repositories/news_content_repository.dart';
import 'package:demoparty_assistant/data/services/news_content_service.dart';
import 'package:demoparty_assistant/utils/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class NewsContentScreen extends StatefulWidget {
  final String title;
  final String image;
  final String articleUrl;

  NewsContentScreen({
    required this.title,
    required this.image,
    required this.articleUrl,
  });

  @override
  _NewsContentScreenState createState() => _NewsContentScreenState();
}

class _NewsContentScreenState extends State<NewsContentScreen> {
  final NewsContentService _newsContentService = NewsContentService(NewsContentRepository());
  List<Widget> _contentWidgets = [];
  String? _publishDate;

  @override
  void initState() {
    super.initState();
    _fetchFullContent();
  }

  Future<void> _fetchFullContent() async {
    try {
      final data = await _newsContentService.fetchFullContent(widget.articleUrl);

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
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.image.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(widget.image, fit: BoxFit.scaleDown, scale: 1,),
                ),
              SizedBox(height: 20),
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 25), // Adjust the fontSize as needed
              ),
              if (_publishDate != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Published on: $_publishDate",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                    ),
                  ),
                ),
              Divider(color: Theme.of(context).dividerColor, thickness: 1),
              ..._contentWidgets,
            ],
          ),
        ),
      ),
    );
  }
}
