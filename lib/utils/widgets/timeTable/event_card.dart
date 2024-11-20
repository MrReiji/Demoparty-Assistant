import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/Theme.dart';

/// A card widget to display event details.
/// Includes title, time, label, and a button to add the event to a calendar.
class EventCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String title;
  final Color color;
  final String label;
  final VoidCallback addToCalendar;

  const EventCard({
    required this.time,
    required this.icon,
    required this.title,
    required this.color,
    required this.label,
    required this.addToCalendar,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.1),
        ),
      ),
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon and Label Section
          Container(
            width: 80,
            height: 70,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: theme.colorScheme.onPrimary,
                  size: AppDimensions.iconSizeMedium,
                ),
                const SizedBox(height: AppDimensions.paddingSmall / 2),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMedium),

          // Title and Time Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dynamic title to ensure full visibility
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSmall),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: AppDimensions.iconSizeSmall,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: AppDimensions.paddingSmall / 2),
                    Text(
                      time,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Calendar Button Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.calendar_today,
                    color: theme.colorScheme.primary,
                    size: AppDimensions.iconSizeMedium,
                  ),
                  onPressed: addToCalendar,
                  tooltip: 'Add to Calendar',
                ),
                const SizedBox(height: AppDimensions.paddingSmall),
                Text(
                  'Add to calendar!',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
