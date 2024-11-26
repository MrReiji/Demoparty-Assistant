import 'package:demoparty_assistant/data/repositories/news_content_repository.dart';
import 'package:demoparty_assistant/utils/widgets/universal/universal_video_player.dart';
import 'package:flutter/material.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:demoparty_assistant/utils/widgets/html_based/text_column_widget.dart';

class NewsContentService {
  final NewsContentRepository _newsContentRepository;

  NewsContentService(this._newsContentRepository);

  Future<Map<String, dynamic>> fetchFullContent(String articleUrl,
      {bool forceRefresh = false}) async {
    final data =
        await _newsContentRepository.fetchContent(articleUrl, forceRefresh: forceRefresh);
    String? publishDate = data['publishDate'];
    List<Widget> contentWidgets = [];

    if (data['contentInnerHtml'] == null) {
      print("[NewsContentService] Warning: 'contentInnerHtml' is null.");
      return {
        'publishDate': publishDate,
        'contentWidgets': [const Text("No content available.")],
      };
    }

    final contentInner = BeautifulSoup(data['contentInnerHtml']!);

    // Generate content widgets using TextColumnWidget
    final textColumnWidget = TextColumnWidget(content: contentInner.body!);
    contentWidgets.add(textColumnWidget);

    // Extract video if present
    if (data['videoUrl'] != null) {
      contentWidgets.insert(
        0,
        UniversalVideoPlayer(
          videoUrl: data['videoUrl']!,
          isEmbedded: true,
        ),
      );
    }

    return {
      'publishDate': publishDate,
      'contentWidgets': contentWidgets,
    };
  }
}
