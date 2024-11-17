import 'package:flutter/material.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';

class Streams extends StatefulWidget {
  @override
  _StreamsState createState() => _StreamsState();
}

class _StreamsState extends State<Streams> {
  List<Map<String, String>> streams = [];
  Map<String, String>? liveStream;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStreams();
  }

  Future<void> fetchStreams() async {
    setState(() {
      isLoading = true;
      print("Rozpoczęto ładowanie strumieni...");
    });

    try {
      await fetchLiveStream();
      await fetchArchiveStreams();
      print("Wszystkie strumienie załadowane pomyślnie.");
    } catch (e) {
      print('Błąd podczas ładowania strumieni: $e');
    }

    setState(() {
      isLoading = false;
      print("Ładowanie strumieni zakończone.");
    });
  }

  Future<void> fetchLiveStream() async {
    print("Rozpoczęto pobieranie strumienia na żywo...");
    try {
      final response = await http.get(Uri.parse('https://scenesat.com/video/1'));
      print("Odpowiedź serwera: ${response.statusCode}");

      if (response.statusCode == 200) {
        final BeautifulSoup soup = BeautifulSoup(response.body);

        // Pobieranie tytułu i opisu strumienia
        final title = soup.find('meta', attrs: {'property': 'og:title'})?.attributes['content'];
        final description = soup.find('meta', attrs: {'property': 'og:description'})?.attributes['content'];

        // Pobieranie adresu URL wideo
        final videoElement = soup.find('video', class_: 'fp-engine');
        final videoUrl = videoElement?.attributes['src'];

        if (title != null && description != null && videoUrl != null) {
          final resolvedUrl = videoUrl.startsWith('blob:') ? videoUrl.substring(5) : videoUrl;

          liveStream = {
            'title': title,
            'description': description,
            'url': resolvedUrl,
          };

          print("Strumień na żywo załadowany: $liveStream");
        } else {
          print("Nie udało się znaleźć danych strumienia na żywo.");
        }
      } else {
        print("Błąd serwera: ${response.statusCode}");
      }
    } catch (e) {
      print('Błąd podczas pobierania strumienia na żywo: $e');
    }
  }

  Future<void> fetchArchiveStreams() async {
    print("Rozpoczęto pobieranie strumieni archiwalnych...");
    try {
      final response = await http.get(Uri.parse('https://scenesat.com/videoarchive'));
      print("Odpowiedź serwera: ${response.statusCode}");

      if (response.statusCode == 200) {
        final BeautifulSoup soup = BeautifulSoup(response.body);
        final streamElements = soup.findAll('div', class_: 'row');

        List<Map<String, String>> parsedStreams = [];

        for (var element in streamElements) {
          final titleElement = element.find('dd');
          final dateElement = element.find('dt');
          final urlElement = element.find('span', class_: 'playersrc')?.attributes['data-url'];

          if (titleElement != null && dateElement != null && urlElement != null) {
            final stream = {
              'title': titleElement.text.trim(),
              'date': dateElement.text.split('[').first.trim(),
              'duration': dateElement.text.split('[').last.replaceAll(']', '').trim(),
              'url': urlElement,
            };
            parsedStreams.add(stream);
            print("Załadowano strumień archiwalny: $stream");
          }
        }

        streams = parsedStreams;
        print("Załadowano ${streams.length} strumieni archiwalnych.");
      } else {
        print("Błąd serwera: ${response.statusCode}");
      }
    } catch (e) {
      print('Błąd podczas pobierania strumieni archiwalnych: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streams'),
      ),
      drawer: AppDrawer(currentPage: 'Streams'),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: theme.colorScheme.primary),
                  const SizedBox(height: 20),
                  Text(
                    'Ładowanie strumieni...',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: (liveStream != null ? 1 : 0) + streams.length,
              itemBuilder: (context, index) {
                if (liveStream != null && index == 0) {
                  return buildLiveStreamCard(context, theme);
                }

                final stream = streams[index - (liveStream != null ? 1 : 0)];
                return buildStreamCard(context, theme, stream);
              },
            ),
    );
  }

  Widget buildLiveStreamCard(BuildContext context, ThemeData theme) {
    print("Tworzenie widoku strumienia na żywo...");
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 10,
      child: InkWell(
        onTap: () {
          print("Strumień na żywo został kliknięty.");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                title: liveStream!['title']!,
                date: liveStream!['description']!,
                url: liveStream!['url']!,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                liveStream!['title']!,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Text(
                liveStream!['description']!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStreamCard(BuildContext context, ThemeData theme, Map<String, String> stream) {
    print("Tworzenie widoku strumienia archiwalnego: ${stream['title']}");
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 8,
      child: InkWell(
        onTap: () {
          print("Strumień archiwalny został kliknięty: ${stream['title']}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                title: stream['title']!,
                date: stream['date']!,
                url: stream['url']!,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stream['title']!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 16, color: theme.colorScheme.onSurface),
                        const SizedBox(width: 5),
                        Text(
                          stream['date']!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.timer, size: 16, color: theme.colorScheme.onSurface),
                        const SizedBox(width: 5),
                        Text(
                          stream['duration']!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 25,
                backgroundColor: theme.colorScheme.primary,
                child: Icon(
                  Icons.play_arrow,
                  color: theme.colorScheme.onPrimary,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String title;
  final String date;
  final String url;

  const VideoPlayerScreen({
    required this.title,
    required this.date,
    required this.url,
  });

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    print("Rozpoczęto inicjalizację odtwarzacza wideo.");
    try {
      _videoPlayerController = VideoPlayerController.network(widget.url);
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
      );

      print("Odtwarzacz wideo został zainicjalizowany.");
      setState(() {});
    } catch (e) {
      print('Błąd odtwarzania wideo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nie można odtworzyć wideo. Sprawdź źródło.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _chewieController != null &&
              _chewieController!.videoPlayerController.value.isInitialized
          ? Chewie(controller: _chewieController!)
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void dispose() {
    print("Zwalnianie zasobów odtwarzacza wideo.");
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
