import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/Theme.dart';

class Streams extends StatelessWidget {
  const Streams({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streams'),
      ),
      drawer: AppDrawer(currentPage: 'Streams',),
      body: StreamList(),
    );
  }
}

class StreamList extends StatelessWidget {
  final List<Map<String, String>> streams = [
    {'title': 'Main Event Stream', 'url': 'https://example.com/stream1'},
    {'title': 'Competitions Live', 'url': 'https://example.com/stream2'},
    {'title': 'Workshops', 'url': 'https://example.com/stream3'},
    {'title': 'Afterparty', 'url': 'https://example.com/stream4'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: streams.length,
      itemBuilder: (context, index) {
        final stream = streams[index];
        return ListTile(
          leading: const Icon(Icons.videocam, color: streamsColor),
          title: Text(stream['title']!),
          subtitle: Text('Watch Live'),
          onTap: () => _openStream(context, stream['url']!),
        );
      },
    );
  }

  void _openStream(BuildContext context, String url) {
    // Open the stream in a webview or browser
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stream Opening'),
        content: Text('Would you like to open this stream?\n$url'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Here you could implement actual link opening
            },
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }
}
