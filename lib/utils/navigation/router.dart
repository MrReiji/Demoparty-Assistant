import 'package:demoparty_assistant/screens/satellites.dart';
import 'package:demoparty_assistant/screens/sponsors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:demoparty_assistant/screens/onboarding.dart';
import 'package:demoparty_assistant/screens/pro.dart';
import 'package:demoparty_assistant/screens/home.dart';
import 'package:demoparty_assistant/screens/profile.dart';
import 'package:demoparty_assistant/screens/settings.dart';
import 'package:demoparty_assistant/screens/register.dart';
import 'package:demoparty_assistant/screens/news.dart';
import 'package:demoparty_assistant/screens/components.dart';
import 'app_router_paths.dart';

class AppRouter {
  static final router = GoRouter(
    // refreshListenable: RouterNotifier(),
    // redirect: (context, state) => RouterNotifier().redirect(context, state),
    initialLocation: AppRouterPaths.onboarding,
    routes: [
      GoRoute(
        name: 'home',
        path: AppRouterPaths.home,
        builder: (BuildContext context, GoRouterState state) {
          return Home();
        },
      ),
      GoRoute(
        name: 'settings',
        path: AppRouterPaths.settings,
        builder: (BuildContext context, GoRouterState state) {
          return Settings();
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
        name: 'pro',
        path: AppRouterPaths.pro,
        builder: (BuildContext context, GoRouterState state) {
          return Pro();
        },
      ),
      GoRoute(
        name: 'profile',
        path: AppRouterPaths.profile,
        builder: (BuildContext context, GoRouterState state) {
          return Profile();
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
        name: 'components',
        path: AppRouterPaths.components,
        builder: (BuildContext context, GoRouterState state) {
          return Components();
        },
      ),
      GoRoute(
        name: 'register',
        path: AppRouterPaths.register,
        builder: (BuildContext context, GoRouterState state) {
          return Register();
        },
      ),
      GoRoute(
        name: 'satellites',
        path: AppRouterPaths.satellites,
        builder: (BuildContext context, GoRouterState state) {
          return SatellitesScreen();
        },
      ),
      GoRoute(
        name: 'sponsors',
        path: AppRouterPaths.sponsors,
        builder: (BuildContext context, GoRouterState state) {
          return SponsorsScreen();
        },
      ),
    ],
  );
}
