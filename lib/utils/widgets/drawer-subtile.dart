import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/app_styles.dart';

class SubDrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final GestureTapCallback? onTap;
  final bool isSelected;
  final Color iconColor;

  SubDrawerTile({
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
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withOpacity(0.2) // Zmieniono na primaryColor
              : backgroundColorEnd.withOpacity(0.1), // Zmieniono na backgroundColorEnd
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? textColorLight : iconColor.withOpacity(0.6), // Zmieniono na textColorLight
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: isSelected
                      ? textColorLight // Zmieniono na textColorLight
                      : textColorLight.withOpacity(0.7), // Zmieniono na textColorLight
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
