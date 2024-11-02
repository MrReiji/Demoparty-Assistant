import 'package:demoparty_assistant/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Light theme configuration
ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: bgColorScreen,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: bgColorScreen,
      iconTheme: IconThemeData(color: textColorPrimary),
    ),
    iconTheme: IconThemeData(color: textColorPrimary),
    textTheme: GoogleFonts.antaTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: textColorPrimary),
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: bgColorScreen,
      selectedItemColor: primaryColor.withOpacity(0.7),
      unselectedItemColor: textColorPrimary.withOpacity(0.32),
      selectedIconTheme: IconThemeData(color: primaryColor),
      showUnselectedLabels: true,
    ),
  );
}

// Dark theme configuration
ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColorEnd, // Dark background color
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: backgroundColorEnd,
      iconTheme: IconThemeData(color: textColorLight),
    ),
    iconTheme: IconThemeData(color: textColorLight),
    textTheme: GoogleFonts.antaTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: textColorLight),
    colorScheme: ColorScheme.dark().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundColorEnd,
      selectedItemColor: textColorLight.withOpacity(0.7),
      unselectedItemColor: textColorLight.withOpacity(0.32),
      selectedIconTheme: IconThemeData(color: primaryColor),
      showUnselectedLabels: true,
    ),
  );
}
