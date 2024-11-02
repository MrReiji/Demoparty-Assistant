import 'package:demoparty_assistant/utils/navigation/app_router_paths.dart';
import 'package:demoparty_assistant/constants/app_styles.dart'; // Import constants
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class Onboarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: appGradientBackground,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Main image with circular shape and shadow
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor.withOpacity(0.5),
                        blurRadius: shadowBlurRadius,
                        offset: shadowOffset,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/imgs/xenium_theme_image.png",
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * mainImageSizeFactor,
                    ),
                  ),
                ),
                SizedBox(height: verticalSpacing),

                // Title text
                Text(
                  "Xenium 2024\nDemoscene Party",
                  style: GoogleFonts.tourney(
                    color: colorScheme.onBackground,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: verticalSpacing),

                // Theme description text
                Text(
                  "This Year's Theme: Folk",
                  style: GoogleFonts.anta(
                    color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                    fontSize: themeFontSize,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: verticalSpacing),

                // Event details (location and date)
                Column(
                  children: [
                    Text(
                      "Łódź, Poland",
                      style: GoogleFonts.anta(
                        color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                        fontSize: locationFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "29.08.2024 - 01.09.2024",
                      style: GoogleFonts.anta(
                        color: theme.textTheme.bodyLarge?.color?.withOpacity(0.6),
                        fontSize: dateFontSize,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: verticalSpacing),

                // "GET STARTED" button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: colorScheme.onPrimary,
                      backgroundColor: colorScheme.primary,
                      padding: EdgeInsets.symmetric(vertical: buttonPadding),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadiusValue),
                      ),
                      elevation: 10,
                      shadowColor: shadowColor,
                    ),
                    onPressed: () {
                      context.go(AppRouterPaths.timeTable);
                    },
                    child: Text(
                      "GET STARTED",
                      style: GoogleFonts.anta(
                        fontSize: buttonFontSize,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
