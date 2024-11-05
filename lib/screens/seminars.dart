import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';

class SeminarsScreen extends StatelessWidget {
  // Seminar data using the provided images
  final List<Map<String, String>> seminars = [
    {
      'title': 'How to scene for beginners',
      'description':
          'Introduction to Revision for newcomers. An opportunity to clear up those things you were too afraid to ask.\n\nIncludes a short presentation about the intranet, entry submission, party information, and useful scene resources. Newcomer mentors will introduce themselves and be available for Q&A.\n\nThis seminar is not intended to be a full-fledged scene history session.\n\nThe slides for this seminar can be downloaded here.',
      'image': 'assets/imgs/seminarPerson1.jpg', // First image provided
      'website': 'https://sceneseminar.com', // Placeholder link
    },
    {
      'title': 'The Demoscene from an American perspective',
      'description':
          'Inverse Phase, museum curator and pizza aficionado, has been following the demoscene for some 35 years. After attending, staffing, and organizing parties in the US, how could this be his first European Demoparty?\n\nGet an insight into the North American side of the scene and ask any questions you\'ve always wanted to know.',
      'image': 'assets/imgs/seminarPerson2.jpg', // Second image provided
      'website': 'https://americanperspective.com', // Placeholder link
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seminars"),
        backgroundColor: Color(0xFF1F1F1F),
      ),
      drawer: AppDrawer(currentPage: "Seminars"),
      backgroundColor: Color(0xFF191919),
      body: ListView.builder(
        itemCount: seminars.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Handle seminar click, e.g., open seminar details or a website
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.asset(
                          seminars[index]['image']!,
                          width: double.infinity,
                          height: 300, // Increased height for better portrait display
                          fit: BoxFit.cover, // Ensures the image is cropped correctly
                          alignment: Alignment.center, // Focus on the center of the image
                        ),
                      ),
                      Container(
                        height: 300, // Match the height of the image
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          gradient: LinearGradient(
                            colors: [Colors.black54, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: StrokeText(
                          text: seminars[index]['title']!,
                          textStyle: GoogleFonts.handjet(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          strokeColor: Colors.black,
                          strokeWidth: 4,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          seminars[index]['description']!,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.grey[300],
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.language, color: Colors.grey[300], size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Website',
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
