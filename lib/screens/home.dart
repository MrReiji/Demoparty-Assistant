import 'package:demoparty_assistant/constants/dummy_data/events.dart';
import 'package:demoparty_assistant/utils/widgets/card-event.dart';
import 'package:demoparty_assistant/utils/widgets/drawer.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Color(0xFF1F1F1F),
      ),
      backgroundColor: Color(0xFF191919),
      drawer: NowDrawer(currentPage: "Home"),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: events.map((day) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day['date'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Column(
                      children: (day['events'] as List<EventCard>).map((event) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: event,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
