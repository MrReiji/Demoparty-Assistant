import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/theme.dart';

/// A widget to display an image with proper error handling and a loading indicator.
/// Ensures consistent design across the app.
class CustomImageWidget extends StatelessWidget {
  final String imageUrl;

  const CustomImageWidget({
    required this.imageUrl,
    Key? key, required String altText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingSmall),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
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
            return Container(
              color: theme.colorScheme.error.withOpacity(0.1),
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image, size: 50),
            );
          },
        ),
      ),
    );
  }
}
