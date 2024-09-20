import 'package:flutter/material.dart';
import 'package:demoparty_assistant/utils/widgets/card-event.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final List<Map<String, dynamic>> events = [
  {
    'date': '27.08.2024, Friday',
    'events': [
      EventCard(
        time: '12:00',
        icon: FontAwesomeIcons.calendarDay,
        title: 'Opening Ceremony\nWelcome to the Demoscene Party!',
        author: 'Organizing Committee',
        color: Colors.blue,
        label: 'Event',
      ),
      EventCard(
        time: '14:00',
        icon: FontAwesomeIcons.chalkboardUser,
        title: 'Seminar on Shader Programming\nLearn advanced techniques',
        author: 'Alice Johnson',
        color: Colors.purple,
        label: 'Seminar',
      ),
      EventCard(
        time: '16:00',
        icon: FontAwesomeIcons.laptopCode,
        title: 'Coding Workshop\nIntro to Real-Time Demos',
        author: 'Mark Wilson',
        color: Colors.indigo,
        label: 'Seminar',
      ),
    ],
  },
  {
    'date': '28.08.2024, Saturday',
    'events': [
      EventCard(
        time: '10:00',
        icon: FontAwesomeIcons.exclamationTriangle,
        title: 'Submission Deadline\nDemo, Graphics, Music Entries',
        author: 'Michael Brown',
        color: Colors.orange,
        label: 'Deadline',
      ),
      EventCard(
        time: '13:00',
        icon: FontAwesomeIcons.music,
        title: 'Live Concert\nChip Tune DJ Set',
        author: 'DJ Chiptune',
        color: Colors.redAccent,
        label: 'Concert',
      ),
      EventCard(
        time: '15:00',
        icon: FontAwesomeIcons.laptopCode,
        title: 'Fast Compo\n1 Hour Coding Challenge',
        author: 'Competition Organizer',
        color: Colors.teal,
        label: 'Compo',
      ),
    ],
  },
  {
    'date': '29.08.2024, Sunday',
    'events': [
      EventCard(
        time: '09:00',
        icon: FontAwesomeIcons.laptopCode,
        title: 'Demo Competition\nShowcase of the best demos',
        author: 'Panel of Judges',
        color: Colors.teal,
        label: 'Compo',
      ),
      EventCard(
        time: '11:00',
        icon: FontAwesomeIcons.penNib,
        title: 'Graphics Competition\nPixel Art and More',
        author: 'Graphics Jury',
        color: Colors.green,
        label: 'Compo',
      ),
      EventCard(
        time: '15:00',
        icon: FontAwesomeIcons.trophy,
        title: 'Award Ceremony\nWinners Announcement',
        author: 'Organizing Committee',
        color: Colors.amber,
        label: 'Event',
      ),
    ],
  },
  {
    'date': '30.08.2024, Monday',
    'events': [
      EventCard(
        time: '12:00',
        icon: FontAwesomeIcons.userFriends,
        title: 'Networking Event\nMeet the Scene',
        author: 'Community Manager',
        color: Colors.blueGrey,
        label: 'Event',
      ),
      EventCard(
        time: '14:00',
        icon: FontAwesomeIcons.microphone,
        title: 'Podcast Recording\nDiscussion on Demoscene History',
        author: 'Podcast Host',
        color: Colors.cyan,
        label: 'Event',
      ),
    ],
  },
];
