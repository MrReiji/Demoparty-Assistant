import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';

class SponsorsScreen extends StatelessWidget {
  final List<Map<String, String>> sponsors = [
    {
      'name': 'Ventuz',
      'category': 'Platinum',
      'description': 'Ventuz Technology is home to 3 absolute legends of the demoscene: Chaos of Farbrausch, kb of Farbrausch, and BoyC of Conspiracy. Ventuz is also home to our legendary Real-Time software and offers cutting-edge real-time data visualization solutions for ProAV and Broadcast.',
      'image': 'assets/imgs/ventuz.jpg', 
      'website': 'https://ventuz.com',
    },
    {
      'name': 'zeit:raum',
      'category': 'Platinum',
      'description': 'The zeit:raum group develops forward-thinking solutions for media, digital, virtual/augmented reality and CGI. Offering holistic strategic consulting and sophisticated film and digital projects from inception to realisation.',
      'image': 'assets/imgs/zeitraum.png',
      'website': 'https://zeitraum.com',
    },
    {
      'name': 'bondix',
      'category': 'Gold',
      'description': 'Bondix is a leader in IT and networking solutions. They specialize in providing secure and reliable VPN services and real-time data transmission technologies, empowering global business communications.',
      'image': 'assets/imgs/bondix.png', 
      'website': 'https://bondix.com',
    },
    {
      'name': 'Private Supporters',
      'category': 'Supporters',
      'description': 'We thank the following people for their tremendous support: Harvey, emoon/TBL, muhmac/Speckdrumm, Punqtured/fnuque, Riker, totetmatt, Weasel/Padua, SINSE JUNE, Lea @Charm Quarks, psykon/mercury, AdeptApril/Monoceros, and many more.',
      'image': 'assets/imgs/supporters.png',
      'website': 'https://supporters.com',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sponsors",
          style: GoogleFonts.oswald(),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF1F1F1F),
      ),
      
      drawer: AppDrawer(currentPage: "Sponsors"),
      backgroundColor: Color(0xFF191919),
      body: ListView.builder(
        itemCount: sponsors.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Akcja po kliknięciu
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15), // Zmniejszony odstęp pionowy dla spójności
              elevation: 5, // Zmniejszenie cienia dla bardziej subtelnego wyglądu
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Lekko zmniejszony radius dla eleganckiego wyglądu
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
                          sponsors[index]['image']!,
                          width: double.infinity,
                          height: 180, // Nieco mniejsza wysokość dla lepszej proporcji
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: 180,
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
                          text: sponsors[index]['name']!,
                          textStyle: GoogleFonts.handjet(
                            fontSize: 22, // Dopasowana wielkość czcionki
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          strokeColor: Colors.black,
                          strokeWidth: 4, // Nieco cieńszy kontur tekstu
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Mniejsze i bardziej spójne odstępy wewnętrzne
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sponsors[index]['category']!,
                          style: GoogleFonts.roboto(
                            fontSize: 14, // Nieco mniejsza czcionka
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4), // Mniejszy odstęp
                        Text(
                          sponsors[index]['description']!,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.grey[300],
                          ),
                        ),
                        SizedBox(height: 10), // Odpowiedni odstęp między opisem a ikonami
                        Row(
                          children: [
                            Icon(Icons.language, color: Colors.grey[300], size: 18), // Mniejsza ikona dla lepszej spójności
                            SizedBox(width: 6),
                            Text(
                              'Website',
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 14, // Czcionka dopasowana do reszty tekstu
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
