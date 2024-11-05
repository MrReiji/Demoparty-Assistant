import 'package:demoparty_assistant/constants/app_styles.dart';
import 'package:demoparty_assistant/constants/models/news_model.dart';
import 'package:demoparty_assistant/screens/news_content.dart';
import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final NewsModel news;

  NewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsContentScreen(
              title: news.title,
              image: news.imageUrl,
              articleUrl: news.articleUrl,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: AspectRatio(
                aspectRatio: 7 / 5,
                child: Image.network(
                  news.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: news.categories.map((category) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: secondaryColor.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.label,
                              color: theme.iconTheme.color!.withOpacity(0.8),
                              size: 16.0,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              category,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withOpacity(0.8),
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  Text(
                    news.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
