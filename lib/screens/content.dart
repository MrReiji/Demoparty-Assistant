import 'package:demoparty_assistant/data/services/content_service.dart';
import 'package:flutter/material.dart';
import 'package:demoparty_assistant/utils/widgets/custom_appbar.dart';
import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';

class ContentScreen extends StatelessWidget {
  final String url;
  final String title;
  final String currentPage;

  const ContentScreen({
    required this.url,
    required this.title,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: title),
      drawer: AppDrawer(currentPage: currentPage),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FutureBuilder<List<Widget>>(
        future: ContentService().fetchContent(url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Wskaźnik ładowania
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Komunikat o błędzie
            return Center(
              child: Text(
                'Błąd podczas ładowania treści',
                style: theme.textTheme.bodyLarge,
              ),
            );
          } else if (snapshot.hasData) {
            // Wyświetlanie pobranej treści
            List<Widget> contentWidgets = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                style: theme.textTheme.bodyLarge,
              ),
            );
          }
        },
      ),
    );
  }
}
