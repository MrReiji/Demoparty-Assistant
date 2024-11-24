import 'package:demoparty_assistant/screens/contact.dart';
import 'package:demoparty_assistant/screens/content.dart';
import 'package:demoparty_assistant/screens/settings.dart';
import 'package:demoparty_assistant/screens/streams.dart';
import 'package:demoparty_assistant/screens/users.dart';
import 'package:demoparty_assistant/screens/voting.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:demoparty_assistant/screens/onboarding.dart';
import 'package:demoparty_assistant/screens/time_table.dart';
import 'package:demoparty_assistant/screens/authorization.dart';
import 'package:demoparty_assistant/screens/news.dart';
import 'app_router_paths.dart';

class AppRouter {
  static final router = GoRouter(
    // refreshListenable: RouterNotifier(),
    // redirect: (context, state) => RouterNotifier().redirect(context, state),
    initialLocation: AppRouterPaths.onboarding,
    routes: [
      GoRoute(
        name: 'TimeTable',
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
        name: 'authentication',
        path: AppRouterPaths.authentication,
        builder: (BuildContext context, GoRouterState state) {
          return Authentication();
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
        name: 'Voting',
        path: AppRouterPaths.voting,
        builder: (BuildContext context, GoRouterState state) {
          // Odczytanie przekazanego sessionCookie ze stanu
          final sessionCookie = state.extra as String;

          return Voting(sessionCookie: sessionCookie);
        },
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
