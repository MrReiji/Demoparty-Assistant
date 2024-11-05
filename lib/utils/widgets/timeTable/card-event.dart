import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String title;
  final Color color; // Ustawienie koloru z parametru
  final String label; // Ustawienie własnego tekstu z parametru

  EventCard({
    required this.time,
    required this.icon,
    required this.title,
    required this.color,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sekcja po lewej: ikona i etykieta
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                const SizedBox(width: 6.0),
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
          const SizedBox(width: 20.0),

          // Sekcja po prawej: tytuł i czas
          Expanded(
            child: Column(  
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tytuł z możliwością zawijania do nowej linii
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 18
                  ),
                ),
                const SizedBox(height: 6.0),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.amberAccent,
                      size: 16.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      time,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.amberAccent,
                        fontWeight: FontWeight.w500,
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
