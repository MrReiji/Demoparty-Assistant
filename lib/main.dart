import 'package:demoparty_assistant/constants/Theme.dart';
import 'package:flutter/material.dart';
import 'package:demoparty_assistant/utils/navigation/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: AppRouter.router.routerDelegate,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routeInformationProvider: AppRouter.router.routeInformationProvider,
      title: 'Demoparty Assistant',
      theme: lightThemeData(context), // Light theme
      darkTheme: darkThemeData(context), // Dark theme
      themeMode: ThemeMode.system, // Follow system theme
      debugShowCheckedModeBanner: false,
    );
  }
}
