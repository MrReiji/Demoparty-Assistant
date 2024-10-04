import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsDetailScreen extends StatelessWidget {
  final String title;
  final String fullContent;
  final String image;

  NewsDetailScreen({
    required this.title,
    required this.fullContent,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text(
          title,
          style: GoogleFonts.oswald(),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF1F1F1F),
      ),
      backgroundColor: Color(0xFF191919),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  image,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),

              // Title of the news article
              Text(
                title,
                style: GoogleFonts.oswald(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),

              // Decorative divider line under the title
              Divider(
                color: Colors.grey[600],
                thickness: 1,
              ),
              SizedBox(height: 15),

              // Introduction section header
              Text(
                'Introduction',
                style: GoogleFonts.oswald(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[200],
                ),
              ),
              SizedBox(height: 10),

              // Full content in one block
              Text(
                fullContent,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.7,
                  color: Colors.grey[300],
                ),
              ),

              SizedBox(height: 20),

              // Additional information section header
              Text(
                'Additional Information',
                style: GoogleFonts.oswald(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[200],
                ),
              ),
              SizedBox(height: 10),

              // List of bullet points with icons
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.info, color: Colors.amber[200]),
                    title: Text(
                      'Highlights from the event.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.music_note, color: Colors.amber[200]),
                    title: Text(
                      'Live music and performances.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
