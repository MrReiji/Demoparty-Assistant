// EventCard.dart
import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/Theme.dart';

class EventCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String title;
  final Color color;
  final String label;

  const EventCard({
    required this.time,
    required this.icon,
    required this.title,
    required this.color,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSmall,
        vertical: AppDimensions.paddingSmall + AppDimensions.paddingSmall / 2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left section: icon and label
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingSmall),
            height: AppDimensions.eventCardIconContainerHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              color: color,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: theme.colorScheme.onPrimary,
                  size: AppDimensions.iconSizeSmall + AppDimensions.paddingSmall, // 20.0
                ),
                SizedBox(width: AppDimensions.paddingSmall),
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppDimensions.paddingLarge),
          // Right section: title and time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppDimensions.paddingSmall / 2),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: theme.colorScheme.secondary,
                      size: AppDimensions.iconSizeSmall, // 16.0
                    ),
                    SizedBox(width: AppDimensions.paddingSmall / 2),
                    Text(
                      time,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
