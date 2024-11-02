import 'package:demoparty_assistant/screens/news_detail.dart';
import 'package:demoparty_assistant/utils/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';

class News extends StatelessWidget {
  final List<Map<String, String>> news = [
    {
      'title': 'Demoscene Party 2024: Full Recap',
      'content':
          'The biggest demoscene party of 2024 just concluded. Read the full recap of events, competitions, and winners!',
      'fullContent':
          'Demoscene Party 2024 was a huge success. The event featured a variety of competitions in categories such as demo, graphics, and music. This year, over 500 participants from all over the world joined... [Read more]',
      'image': 'assets/imgs/demoparty.jpg', // Added image path
    },
    {
      'title': 'New Tools for Demo Artists Released',
      'content':
          'Exciting new tools have been released to help demo artists improve their creations. Check them out!',
      'fullContent':
          'Several new tools aimed at helping demo artists push the boundaries of real-time graphics have been released. Among them is ShaderX, a real-time rendering tool that simplifies... [Read more]',
      'image': 'assets/imgs/demoparty2.jpg', // Added image path
    },
    {
      'title': 'Interview with Last Year\'s Winner',
      'content':
          'We sat down with the winner of last year\'s Demo Competition to talk about his inspiration and process.',
      'fullContent':
          'In this exclusive interview, we talk to John Doe, winner of last year\'s Demo Competition. He shares insights into his workflow, inspiration, and future projects. Learn how... [Read more]',
      'image': 'assets/imgs/demoparty3.jpg', // Added image path
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demoparty News"),
        backgroundColor: Color(0xFF1F1F1F),
      ),
      drawer: AppDrawer(currentPage: "News"),
      backgroundColor: Color(0xFF191919),
      body: ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailScreen(
                    title: news[index]['title']!,
                    fullContent: news[index]['fullContent']!,
                    image: news[index]['image']!, // Passing image path
                  ),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: Image.asset(
                          news[index]['image']!, // Using dynamic image
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          gradient: LinearGradient(
                            colors: [Colors.black54, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: StrokeText(
                          text: news[index]['title']!,
                          textStyle: GoogleFonts.handjet(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          strokeColor: Colors.black,
                          strokeWidth: 5,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      news[index]['content']!,
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            Colors.grey[300], // Zmieniono na jaśniejszy kolor
                      ),
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


