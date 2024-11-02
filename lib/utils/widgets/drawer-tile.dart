import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/app_styles.dart';

class DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final GestureTapCallback? onTap;
  final bool isSelected;
  final Color iconColor;

  DrawerTile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
    this.iconColor = textColorPrimary, // Zmieniono na textColorPrimary
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withOpacity(0.3) // Zmieniono na primaryColor
              : backgroundColorEnd.withOpacity(0.15), // Zmieniono na backgroundColorEnd
          borderRadius: BorderRadius.circular(borderRadiusValue),
          border: Border.all(
            color: isSelected
                ? primaryColor // Zmieniono na primaryColor
                : textColorLight.withOpacity(0.1), // Zmieniono na textColorLight
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? textColorLight : iconColor.withOpacity(0.8), // Zmieniono na textColorLight
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  letterSpacing: 0.2,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: isSelected
                      ? textColorLight // Zmieniono na textColorLight
                      : textColorLight.withOpacity(0.8), // Zmieniono na textColorLight
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
