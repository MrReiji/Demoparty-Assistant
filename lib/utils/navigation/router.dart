import 'package:demoparty_assistant/screens/contact.dart';
import 'package:demoparty_assistant/screens/content.dart';
import 'package:demoparty_assistant/screens/settings.dart';
import 'package:demoparty_assistant/screens/streams.dart';
import 'package:demoparty_assistant/screens/users.dart';
import 'package:demoparty_assistant/screens/voting.dart';
import 'package:demoparty_assistant/screens/voting_results.dart';
import 'package:demoparty_assistant/utils/navigation/auth_path_guard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:demoparty_assistant/screens/onboarding.dart';
import 'package:demoparty_assistant/screens/time_table.dart';
import 'package:demoparty_assistant/screens/authorization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:demoparty_assistant/screens/news.dart';
import 'app_router_paths.dart';

class AppRouter {
  static final authGuard = AuthGuard();
  static final router = GoRouter(
    initialLocation: AppRouterPaths.onboarding,
    routes: [
      GoRoute(
        name: 'timeTable',
        path: AppRouterPaths.timeTable,
        builder: (BuildContext context, GoRouterState state) {
          return TimeTable();
        },
      ),
      GoRoute(
        name: 'onboarding',
        path: AppRouterPaths.onboarding,
        builder: (BuildContext context, GoRouterState state) {
          return Onboarding();
        },
      ),
      GoRoute(
        name: 'news',
        path: AppRouterPaths.news,
        builder: (BuildContext context, GoRouterState state) {
          return News();
        },
      ),
      GoRoute(
        name: 'streams',
        path: AppRouterPaths.streams,
        builder: (BuildContext context, GoRouterState state) {
          return Streams();
        },
      ),
      GoRoute(
        name: 'authorization',
        path: AppRouterPaths.authorization,
        builder: (BuildContext context, GoRouterState state) {
          return Authorization();
        },
      ),
      GoRoute(
        name: 'contact',
        path: AppRouterPaths.contact,
        builder: (BuildContext context, GoRouterState state) {
          return const ContactScreen();
        },
      ),
      GoRoute(
        name: 'users',
        path: AppRouterPaths.users,
        builder: (BuildContext context, GoRouterState state) {
          return const UsersScreen();
        },
      ),
      GoRoute(
      path: '/voting_results',
      builder: (context, state) => VotingResultsScreen(),
      redirect: (context, state) async => await authGuard.redirect(state), // Guarded route.
    ),
    GoRoute(
      path: '/voting',
      builder: (context, state) => VotingScreen(),
      redirect: (context, state) async => await authGuard.redirect(state), // Guarded route.
    ),
      GoRoute(
        name: 'content',
        path: AppRouterPaths.content,
        builder: (BuildContext context, GoRouterState state) {
          final url = state.uri.queryParameters['url']!;
          final title = state.uri.queryParameters['title']!;
          return ContentScreen(
            url: url,
            title: title,
            currentPage: title,
          );
        },
      ),
      GoRoute(
        name: 'settings',
        path: AppRouterPaths.settings,
        builder: (BuildContext context, GoRouterState state) {
          return SettingsScreen();
        },
      ),
    ],
  );
}
