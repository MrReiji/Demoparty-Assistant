import 'package:flutter/material.dart';

class ParagraphWidget extends StatelessWidget {
  final String text;

  const ParagraphWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.6),
      ),
    );
  }
}
