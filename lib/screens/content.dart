import 'package:flutter/material.dart';
import 'package:demoparty_assistant/data/services/content_service.dart';
import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';
import 'package:demoparty_assistant/constants/theme.dart';


class ContentScreen extends StatelessWidget {
  final String url;
  final String title;
  final String currentPage;

  const ContentScreen({
    required this.url,
    required this.title,
    required this.currentPage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
      ),
      drawer: AppDrawer(currentPage: currentPage),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FutureBuilder<List<Widget>>(
        future: ContentService().fetchContent(url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Wskaźnik ładowania
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          } else if (snapshot.hasError) {
            // Komunikat o błędzie
            return Center(
              child: Text(
                'Błąd podczas ładowania treści',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            );
          } else if (snapshot.hasData) {
            // Wyświetlanie pobranej treści
            List<Widget> contentWidgets = snapshot.data!;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingSmall,
                vertical: AppDimensions.paddingSmall,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: contentWidgets,
              ),
            );
          } else {
            // Przypadek braku danych
            return Center(
              child: Text(
                'Brak treści do wyświetlenia',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
