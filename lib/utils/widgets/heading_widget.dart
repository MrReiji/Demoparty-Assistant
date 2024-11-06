import 'package:flutter/material.dart';

class HeadingWidget extends StatelessWidget {
  final String text;
  final int level;

  const HeadingWidget({required this.text, required this.level});

  @override
  Widget build(BuildContext context) {
    TextStyle style;
    switch (level) {
      case 1:
        style = Theme.of(context).textTheme.headlineLarge!;
        break;
      case 2:
        style = Theme.of(context).textTheme.headlineMedium!;
        break;
      case 3:
        style = Theme.of(context).textTheme.headlineSmall!;
        break;
      case 4:
        style = Theme.of(context).textTheme.titleLarge!;
        break;
      case 5:
        style = Theme.of(context).textTheme.titleMedium!;
        break;
      default:
        style = Theme.of(context).textTheme.titleSmall!;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
