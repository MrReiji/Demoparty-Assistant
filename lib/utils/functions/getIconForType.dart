import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

IconData getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'event':
        return FontAwesomeIcons.calendarDay;
      case 'seminar':
        return FontAwesomeIcons.chalkboardUser;
      case 'concert':
        return FontAwesomeIcons.music;
      case 'deadline':
        return FontAwesomeIcons.exclamationTriangle;
      case 'compo':
        return FontAwesomeIcons.laptopCode;
      default:
        return FontAwesomeIcons.infoCircle;
    }
  }