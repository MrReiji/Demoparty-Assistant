import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/material.dart';

class CustomListWidget extends StatelessWidget {
  final Bs4Element content;

  /// A custom widget to display elements from an HTML `<ul>` and `<li>` list,
  /// ignoring unnecessary `<p>` elements or empty lists.
  const CustomListWidget({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // List of ignored `<ul>` classes
    const ignoredClasses = [
      'menu',
      'sf-menu',
      'sub-menu',
      'buttons',
      'social',
      'secondary-header-items',
    ];

    // Ignore the `<ul>` if it has any ignored classes
    final ulClasses = content.attributes['class'] ?? '';
    if (_hasIgnoredClass(ulClasses, ignoredClasses) || _isEmptyList(content)) {
      return const SizedBox.shrink();
    }

    // Extract all `<li>` items
    final listItems = content.findAll('li');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: listItems.map((li) {
          final listItemText = li.text.trim();

          if (listItemText.isEmpty) {
            return const SizedBox.shrink(); // Ignore empty list items
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.circle, size: 8, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    listItemText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Checks if a `<ul>` element and all its descendants are effectively empty.
  bool _isEmptyList(Bs4Element ulElement) {
    final listItems = ulElement.findAll('li');
    return listItems.isEmpty || listItems.every((li) => li.text.trim().isEmpty);
  }

  /// Checks if any of the ignored classes are present in the `<ul>` element's class attribute.
  bool _hasIgnoredClass(String classes, List<String> ignoredClasses) {
    final classList = classes.split(' ');
    return classList.any((cls) => ignoredClasses.contains(cls));
  }
}
