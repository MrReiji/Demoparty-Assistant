// LinksSectionWidget.dart
import 'package:demoparty_assistant/constants/Theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinksSectionWidget extends StatelessWidget {
  final List<Map<String, String>> collectedLinks;

  const LinksSectionWidget({required this.collectedLinks, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.paddingMedium - AppDimensions.paddingSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Links:',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onBackground,
            ),
          ),
          for (var link in collectedLinks)
            Padding(
              padding: EdgeInsets.only(top: AppDimensions.paddingSmall / 2),
              child: GestureDetector(
                onTap: () async {
                  final url = link['url']!;
                  if (await canLaunch(url)) {
                    await launch(url);
                  }
                },
                child: Text(
                  link['text']!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary.withAlpha(AppOpacities.linkAlpha),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
