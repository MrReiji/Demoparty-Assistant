import 'package:demoparty_assistant/data/repositories/news_content_repository.dart';
import 'package:demoparty_assistant/utils/widgets/news/bullet_list_widget.dart';
import 'package:demoparty_assistant/utils/widgets/news/links_section_widget.dart';
import 'package:demoparty_assistant/utils/widgets/news/paragraph_widget.dart';
import 'package:demoparty_assistant/utils/widgets/universal/universal_video_player.dart';
import 'package:flutter/material.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';

class NewsContentService {
  final NewsContentRepository _newsContentRepository;

  NewsContentService(this._newsContentRepository);

  Future<Map<String, dynamic>> fetchFullContent(String articleUrl) async {
    final data = await _newsContentRepository.fetchContent(articleUrl);
    String? publishDate = data['publishDate'];
    List<Widget> contentWidgets = [];
    List<Map<String, String>> collectedLinks = [];

    if (data['contentInnerHtml'] == null) {
      print("[NewsContentService] Warning: 'contentInnerHtml' is null.");
      return {
        'publishDate': publishDate,
        'contentWidgets': [const Text("No content available.")],
        'collectedLinks': collectedLinks,
      };
    }

    final contentInner = BeautifulSoup(data['contentInnerHtml']!);
    _parseContent(contentInner, contentWidgets, collectedLinks);

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
      'collectedLinks': collectedLinks,
    };
  }

  void _parseContent(
    BeautifulSoup contentElement,
    List<Widget> contentWidgets,
    List<Map<String, String>> collectedLinks,
  ) {
    void findParagraphs(Bs4Element element) {
      for (var child in element.children) {
        if (child.name == 'p') {
          String processedText =
              _newsContentRepository.replaceProtectedEmails(child.text).trim();
          if (processedText.isNotEmpty) {
            contentWidgets.add(ParagraphWidget(text: processedText));
          }

          var links = child.findAll('a');
          for (var link in links) {
            String linkText = link.text.trim();
            String? linkHref = link.attributes['href'];
            if (linkHref != null &&
                linkText.isNotEmpty &&
                !linkHref.contains("email-protection")) {
              collectedLinks.add({'text': linkText, 'url': linkHref});
            }
          }
        } else if (child.name == 'ul') {
          contentWidgets.add(BulletListWidget(ulElement: child));
        } else if (child.name == 'div') {
          findParagraphs(child);
        }
      }
    }

    findParagraphs(contentElement.body!);

    if (collectedLinks.isNotEmpty) {
      contentWidgets.add(LinksSectionWidget(collectedLinks: collectedLinks));
    }
  }
}
