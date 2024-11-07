// CustomImageWidget.dart
import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/theme.dart';

class CustomImageWidget extends StatelessWidget {
  final String imageUrl;

  const CustomImageWidget({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Text(
            'Nie można załadować obrazu',
            style: theme.textTheme.bodyLarge,
          );
        },
      ),
    );
  }
}
