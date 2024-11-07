import 'package:flutter/material.dart';
import 'package:demoparty_assistant/utils/navigation/app_router_paths.dart';
import 'package:go_router/go_router.dart';
import 'package:demoparty_assistant/constants/Theme.dart';


class Onboarding extends StatelessWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: appGradientBackground,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Główne zdjęcie z kształtem koła i cieniem
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor.withOpacity(0.5),
                        blurRadius: 10.0, // Możesz zdefiniować blurRadius w theme.dart
                        offset: Offset(0, 4), // Możesz zdefiniować offset w theme.dart
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/imgs/xenium_theme_image.png",
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 0.6,
                    ),
                  ),
                ),
                SizedBox(height: AppDimensions.paddingLarge),

                // Tekst tytułu
                Text(
                  "Xenium 2024\nDemoscene Party",
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: theme.colorScheme.onBackground,
                    letterSpacing: 1,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimensions.paddingLarge),

                // Opis motywu
                Text(
                  "This Year's Theme: Folk",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimensions.paddingLarge),

                // Szczegóły wydarzenia (lokalizacja i data)
                Column(
                  children: [
                    Text(
                      "Łódź, Poland",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppDimensions.paddingSmall),
                    Text(
                      "29.08.2024 - 01.09.2024",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyLarge?.color?.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.paddingLarge),

                // Przycisk "GET STARTED"
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                      ),
                      elevation: AppDimensions.elevation,
                      shadowColor: shadowColor,
                    ),
                    onPressed: () {
                      context.go(AppRouterPaths.timeTable);
                    },
                    child: Text(
                      "GET STARTED",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: theme.colorScheme.onPrimary,
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
