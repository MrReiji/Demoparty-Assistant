import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/app_styles.dart';

class SubDrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final GestureTapCallback? onTap;
  final bool isSelected;
  final Color? iconColor;

  SubDrawerTile({
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
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withOpacity(0.2)
              : backgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? iconThemeColor
                  : (iconColor ?? iconThemeColor)?.withOpacity(0.6),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: isSelected
                      ? textColor
                      : textColor.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
