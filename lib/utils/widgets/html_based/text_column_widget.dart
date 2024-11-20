import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/material.dart';
import 'custom_list_widget.dart';

/// A widget that processes HTML content with paragraphs (`<p>`), hyperlinks (`<a>`),
/// and unordered lists (`<ul>`), preserving their original order in the document.
class TextColumnWidget extends StatelessWidget {
  final Bs4Element content;

  /// Creates a TextColumnWidget for processing and rendering HTML content.
  const TextColumnWidget({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Process all children of the content element
    final children = content.children;
    final List<Widget> widgets = [];
    final List<Map<String, String>> collectedLinks = [];

    for (final child in children) {
      if (child.name == 'div') {
        // Process elements inside the div
        for (final innerChild in child.children) {
          _processElement(innerChild, widgets, collectedLinks, theme);
        }
      } else {
        // Process the current child if it's not a div
        _processElement(child, widgets, collectedLinks, theme);
      }
    }

    // Append a "Links" section if any links were collected
    if (collectedLinks.isNotEmpty) {
      widgets.add(_buildLinksSection(context, collectedLinks));
    }

    // Return a column containing all the processed paragraphs, lists, and links
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  /// Processes individual elements (`<p>`, `<ul>`, etc.) and adds them to widgets.
  void _processElement(Bs4Element element, List<Widget> widgets,
      List<Map<String, String>> collectedLinks, ThemeData theme) {
    if (element.name == 'p') {
      _addParagraphWidget(element, widgets, theme);
      _collectLinksFromParagraph(element, collectedLinks);
    } else if (element.name == 'ul') {
      widgets.add(CustomListWidget(content: element));
    }
  }

  /// Adds a paragraph widget from the given `Bs4Element`.
  void _addParagraphWidget(
      Bs4Element paragraph, List<Widget> widgets, ThemeData theme) {
    final paragraphText = paragraph.text.trim();
    if (paragraphText.isNotEmpty) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Text(
            paragraphText,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 16,
              height: 1.6, // Increased line height for readability
            ),
          ),
        ),
      );
    }
  }

  /// Collects all hyperlinks (`<a>`) within a paragraph.
  void _collectLinksFromParagraph(
      Bs4Element paragraph, List<Map<String, String>> collectedLinks) {
    final links = paragraph.findAll('a');
    for (final link in links) {
      final linkText = link.text.trim();
      final linkHref = link.attributes['href'];
      if (linkHref != null && linkText.isNotEmpty) {
        collectedLinks.add({'text': linkText, 'url': linkHref});
      }
    }
  }

  /// Builds a "Links" section summarizing all collected hyperlinks.
  Widget _buildLinksSection(
      BuildContext context, List<Map<String, String>> links) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Links:',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          for (final link in links)
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: GestureDetector(
                onTap: () async {
                  final url = link['url']!;
                  debugPrint("Navigating to: $url");
                  // Use url_launcher to open links in a browser if needed
                  // if (await canLaunch(url)) await launch(url);
                },
                child: Text(
                  link['text']!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
