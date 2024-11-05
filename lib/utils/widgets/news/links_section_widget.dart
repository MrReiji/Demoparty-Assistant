import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinksSectionWidget extends StatelessWidget {
  final List<Map<String, String>> collectedLinks;

  const LinksSectionWidget({required this.collectedLinks});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(
            'Links:',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontSize: 20.0,
            ),
            ),
          for (var link in collectedLinks)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: GestureDetector(
                onTap: () async {
                  if (await canLaunch(link['url']!)) {
                    await launch(link['url']!);
                  }
                },
                child: Text(
                  link['text']!,
                  style: TextStyle(
                  color: Theme.of(context).colorScheme.primary.withAlpha(200),
                  decoration: TextDecoration.underline,
                  fontSize: 16.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
