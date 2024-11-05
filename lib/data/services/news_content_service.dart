import 'package:demoparty_assistant/data/repositories/news_content_repository.dart';
import 'package:demoparty_assistant/utils/widgets/news/bullet_list_widget.dart';
import 'package:demoparty_assistant/utils/widgets/news/links_section_widget.dart';
import 'package:demoparty_assistant/utils/widgets/news/paragraph_widget.dart';
import 'package:demoparty_assistant/utils/widgets/news/yt_video_widget.dart';
import 'package:flutter/material.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NewsContentService {
  final NewsContentRepository _newsContentRepository;

  NewsContentService(this._newsContentRepository);

  /// Fetches and processes the full content of a news article.
  Future<Map<String, dynamic>> fetchFullContent(String articleUrl) async {
    final data = await _newsContentRepository.fetchContent(articleUrl);
    String? publishDate = data['publishDate'];
    List<Widget> contentWidgets = [];
    List<Map<String, String>> collectedLinks = [];

    // Parse the main content section of the article
    _parseContent(data['contentInner'], contentWidgets, collectedLinks);

    // Add YouTube video widget if a valid video URL is found
    if (data['videoUrl'] != null) {
      final videoId = YoutubePlayer.convertUrlToId(data['videoUrl']!);
      if (videoId != null) {
        contentWidgets.insert(0, YoutubeVideoWidget(videoId: videoId));
      }
    }

    return {
      'publishDate': publishDate,
      'contentWidgets': contentWidgets,
      'collectedLinks': collectedLinks,
    };
  }

  /// Parses HTML content, collecting paragraphs, links, and other elements.
  void _parseContent(Bs4Element? contentElement, List<Widget> contentWidgets, List<Map<String, String>> collectedLinks) {
  if (contentElement == null) return;

  // Helper function to recursively parse paragraphs
  void findParagraphs(Bs4Element element) {
    for (var child in element.children) {
      if (child.name == 'p') {
        // Replacing protected emails and trimming whitespace
        String processedText = _newsContentRepository.replaceProtectedEmails(child.text).trim();

        // Condition to check if the processed text is non-empty before adding
        if (processedText.isNotEmpty) {
          contentWidgets.add(ParagraphWidget(text: processedText));
        }

        // Collecting links only if they are valid and non-empty
        var links = child.findAll('a');
        for (var link in links) {
          String linkText = link.text.trim();
          String? linkHref = link.attributes['href'];
          // Checking that both the link text and href are non-empty
          if (linkHref != null && linkText.isNotEmpty && !linkHref.contains("email-protection")) {
            collectedLinks.add({'text': linkText, 'url': linkHref});
          }
        }
      } else if (child.name == 'ul') {
        contentWidgets.add(BulletListWidget(ulElement: child));
      } else if (child.name == 'div') {
        findParagraphs(child); // Recursive call to parse nested divs
      }
    }
  }

  findParagraphs(contentElement);

  // Adding LinksSectionWidget only if there are collected links
  if (collectedLinks.isNotEmpty) {
    contentWidgets.add(LinksSectionWidget(collectedLinks: collectedLinks));
  }
}

}
