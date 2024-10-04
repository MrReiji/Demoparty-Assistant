import 'package:demoparty_assistant/utils/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';

class SatellitesScreen extends StatelessWidget {
  final List<Map<String, String>> satellites = [
    {
      'title': 'Revision Satellite by Demodulation Party',
      'location': 'Russia',
      'address': 'Sadovnicheskaya str. 82c2, BC Aurora, entrance 5, Moscow, Russia',
      'visitors': '25 visitors',
      'image': 'assets/imgs/revision_satellite.png',
    },
    {
      'title': 'Satellite by Spain Group',
      'location': 'Spain',
      'address': 'Some address in Spain, City, Spain',
      'visitors': '50 visitors',
      'image': 'assets/imgs/satellite.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Satellite Events",
          style: GoogleFonts.oswald(),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF1F1F1F),
      ),
      
      drawer: NowDrawer(currentPage: "Satellites"),
      backgroundColor: Color(0xFF191919),
      body: ListView.builder(
        itemCount: satellites.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Akcja po kliknięciu
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
                          satellites[index]['image']!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.fitWidth,
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
                          text: satellites[index]['title']!,
                          textStyle: GoogleFonts.handjet(
                            fontSize: 24,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          satellites[index]['location']!,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Colors.grey[300],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          satellites[index]['address']!,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.grey[300],
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.people, color: Colors.grey[300]),
                            SizedBox(width: 8),
                            Text(
                              satellites[index]['visitors']!,
                              style: TextStyle(color: Colors.grey[300]),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.language, color: Colors.grey[300]),
                            SizedBox(width: 8),
                            Text(
                              'Website',
                              style: TextStyle(color: Colors.grey[300]),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.mail, color: Colors.grey[300]),
                            SizedBox(width: 8),
                            Text(
                              'Contact',
                              style: TextStyle(color: Colors.grey[300]),
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
