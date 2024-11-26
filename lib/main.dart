import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/theme/theme.dart';
import 'package:demoparty_assistant/utils/navigation/router.dart';
import 'package:demoparty_assistant/data/services/service_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all services and dependencies
  await ServiceManager.initialize();

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
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
    );
  }
}
