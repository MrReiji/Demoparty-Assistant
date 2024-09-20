import 'package:demoparty_assistant/constants/Theme.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String title;
  final String author;
  final Color color; // Nowy parametr do ustawienia koloru
  final String label; // Nowy parametr do ustawienia własnego tekstu

  EventCard({
    required this.time,
    required this.icon,
    required this.title,
    required this.author,
    this.color = NowUIColors.primary, // Domyślny kolor, jeśli nie podany
    this.label = 'Event', // Domyślny tekst, jeśli nie podany
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
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
              color: color, // Zmienny kolor z parametru
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.black87,
                  size: 20.0,
                ),
                SizedBox(width: 6.0),
                Text(
                  label, // Zmienny tekst z parametru
                  style: TextStyle(
                    color: Colors.black87,
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      author,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.0,
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
