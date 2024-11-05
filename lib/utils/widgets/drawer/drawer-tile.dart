import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/app_styles.dart';

class DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final GestureTapCallback? onTap;
  final bool isSelected;
  final Color? iconColor;

  DrawerTile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final iconThemeColor = theme.iconTheme.color;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withOpacity(0.3)
              : backgroundColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(borderRadiusValue),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : textColor.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? iconThemeColor
                  : (iconColor ?? iconThemeColor)?.withOpacity(0.8),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isSelected
                      ? textColor
                      : textColor.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
