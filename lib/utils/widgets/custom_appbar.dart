// CustomAppBar.dart
import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/Theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: Text(title),
      backgroundColor: theme.appBarTheme.backgroundColor,
      surfaceTintColor: theme.colorScheme.secondary,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppDimensions.appBarHeight);
}
