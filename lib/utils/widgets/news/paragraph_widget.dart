// ParagraphWidget.dart
import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/Theme.dart';

class ParagraphWidget extends StatelessWidget {
  final String text;

  const ParagraphWidget({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: AppDimensions.paragraphFontSize,
              height: AppDimensions.textLineHeight,
            ),
      ),
    );
  }
}
