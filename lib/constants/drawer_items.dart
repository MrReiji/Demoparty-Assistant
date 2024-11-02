import 'package:demoparty_assistant/utils/navigation/app_router_paths.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:demoparty_assistant/constants/app_styles.dart'; // Import global styles

final List<Map<String, dynamic>> drawerItems = [
  {
    'icon': FontAwesomeIcons.infoCircle,
    'title': 'About the Party',
    'page': null,
    'iconColor': primaryColor, // Use primary color from app styles
    'subItems': [
      {
        'icon': FontAwesomeIcons.bullhorn,
        'title': 'Xenium Party',
        'page': 'XeniumParty',
        'route': AppRouterPaths.onboarding,
        'iconColor': primaryColor,
      },
      {
        'icon': FontAwesomeIcons.users,
        'title': 'Organizers',
        'page': 'Organizers',
        'route': AppRouterPaths.onboarding,
        'iconColor': primaryColor,
      },
      {
        'icon': FontAwesomeIcons.exclamationTriangle,
        'title': 'Important Changes',
        'page': 'ImportantChanges',
        'route': AppRouterPaths.onboarding,
        'iconColor': warningColor, // Use warning color from app styles
      },
      {
        'icon': FontAwesomeIcons.question,
        'title': 'First Time Visitor?',
        'page': 'FirstTimeVisitor',
        'route': AppRouterPaths.onboarding,
        'iconColor': primaryColor,
      },
    ]
  },
  {
    'icon': FontAwesomeIcons.newspaper,
    'title': 'News',
    'page': 'News',
    'route': AppRouterPaths.news,
    'iconColor': primaryColor,
  },
  {
    'icon': FontAwesomeIcons.calendar,
    'title': 'Timetable',
    'page': 'Timetable',
    'route': AppRouterPaths.timeTable,
    'iconColor': primaryColor,
  },
  {
    'icon': FontAwesomeIcons.trophy,
    'title': 'Competitions',
    'page': null,
    'iconColor': infoColor, // Use info color from app styles
    'subItems': [
      {
        'icon': FontAwesomeIcons.book,
        'title': 'General Rules',
        'page': 'GeneralRules',
        'route': AppRouterPaths.onboarding,
        'iconColor': infoColor,
      },
      {
        'icon': FontAwesomeIcons.desktop,
        'title': 'Demo',
        'page': 'Demo',
        'route': AppRouterPaths.onboarding,
        'iconColor': infoColor,
      },
      {
        'icon': FontAwesomeIcons.code,
        'title': 'Intro',
        'page': 'Intro',
        'route': AppRouterPaths.onboarding,
        'iconColor': infoColor,
      },
    ]
  },
  {
    'icon': FontAwesomeIcons.handsHelping,
    'title': 'Get Involved',
    'page': null,
    'iconColor': successColor, // Use success color from app styles
    'subItems': [
      {
        'icon': FontAwesomeIcons.ticketAlt,
        'title': 'Admission',
        'page': 'Admission',
        'route': AppRouterPaths.onboarding,
        'iconColor': successColor,
      },
      {
        'icon': FontAwesomeIcons.signInAlt,
        'title': 'Register',
        'page': 'Register',
        'route': AppRouterPaths.register,
        'iconColor': successColor,
      },
      {
        'icon': FontAwesomeIcons.fileUpload,
        'title': 'Submit Work',
        'page': 'SubmitWork',
        'route': AppRouterPaths.onboarding,
        'iconColor': successColor,
      },
      {
        'icon': FontAwesomeIcons.gavel,
        'title': 'Rules',
        'page': 'Rules',
        'route': AppRouterPaths.onboarding,
        'iconColor': successColor,
      },
    ]
  },
  {
    'icon': FontAwesomeIcons.mapMarkerAlt,
    'title': 'Location',
    'page': null,
    'iconColor': warningColor,
    'subItems': [
      {
        'icon': FontAwesomeIcons.car,
        'title': 'Transportation & Parking',
        'page': 'TransportationParking',
        'route': AppRouterPaths.onboarding,
        'iconColor': warningColor,
      },
      {
        'icon': FontAwesomeIcons.bed,
        'title': 'Accommodation',
        'page': 'Accommodation',
        'route': AppRouterPaths.onboarding,
        'iconColor': warningColor,
      },
      {
        'icon': FontAwesomeIcons.map,
        'title': 'Party Place',
        'page': 'PartyPlace',
        'route': AppRouterPaths.onboarding,
        'iconColor': warningColor,
      },
    ]
  },
];
