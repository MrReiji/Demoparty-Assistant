import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String title;
  final String author;
  final Color color; // Ustawienie koloru z parametru
  final String label; // Ustawienie własnego tekstu z parametru

  EventCard({
    required this.time,
    required this.icon,
    required this.title,
    required this.author,
    this.color = const Color(0xFF1B1B1B), // Domyślny kolor, jeśli brak theme
    this.label = 'Event',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.0),
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color, // Kolor z parametru lub domyślny
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: theme.colorScheme.onPrimary,
                  size: 20.0,
                ),
                SizedBox(width: 6.0),
                Text(
                  label, // Tekst etykiety
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Text(
                      time,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      author,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
