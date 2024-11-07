// BulletListWidget.dart
import 'package:flutter/material.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:demoparty_assistant/constants/theme.dart';

class BulletListWidget extends StatelessWidget {
  final Bs4Element ulElement;

  const BulletListWidget({required this.ulElement, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final liElements = ulElement.findAll('li');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: liElements.map((liElement) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall / 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• ", style: theme.textTheme.bodyLarge),
              Expanded(
                child: Text(
                  liElement.text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
