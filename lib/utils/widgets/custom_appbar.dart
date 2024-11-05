import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({required this.title});

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
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
