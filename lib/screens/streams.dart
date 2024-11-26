import 'package:demoparty_assistant/data/services/streams_service.dart';
import 'package:demoparty_assistant/screens/video_player_screen.dart';
import 'package:demoparty_assistant/utils/widgets/universal/universal_video_player.dart';
import 'package:demoparty_assistant/utils/widgets/universal/errors/error_display_widget.dart';
import 'package:demoparty_assistant/utils/widgets/universal/errors/error_helper.dart';
import 'package:demoparty_assistant/utils/widgets/universal/loading/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';

/// Displays live and archived streams fetched from the web with search functionality.
class Streams extends StatefulWidget {
  @override
  _StreamsState createState() => _StreamsState();
}

class _StreamsState extends State<Streams> {
  List<Map<String, String>> streams = [];
  List<Map<String, String>> filteredStreams = [];
  Map<String, String>? liveStream;
  bool isLoading = true;
  String? errorMessage;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStreams();
    searchController.addListener(_filterStreams);
  }

  /// Fetches both live and archived streams and updates the UI.
  Future<void> fetchStreams({bool forceRefresh = false}) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      liveStream = await StreamsService.fetchLiveStream();
      streams = await StreamsService.fetchArchiveStreams();
      filteredStreams = List.from(streams); // Initialize with all streams
    } catch (e) {
      ErrorHelper.handleError(e);
      setState(() => errorMessage = ErrorHelper.getErrorMessage(e));
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// Filters streams based on the search query.
  void _filterStreams() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredStreams = streams.where((stream) {
        return stream['title']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streams'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => fetchStreams(forceRefresh: true),
            tooltip: "Refresh Streams",
          ),
        ],
      ),
      drawer: AppDrawer(currentPage: 'Streams'),
      body: isLoading
          ? const LoadingWidget(
              title: "Loading Streams",
              message: "Please wait while we fetch the latest streams.",
            )
          : errorMessage != null
              ? ErrorDisplayWidget(
                  title: "Error Loading Streams",
                  message: errorMessage!,
                  onRetry: () => fetchStreams(forceRefresh: true),
                )
              : _buildContent(theme),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search streams',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: (liveStream != null ? 1 : 0) + filteredStreams.length,
            itemBuilder: (context, index) {
              if (liveStream != null && index == 0) {
                return _buildLiveStreamCard(theme);
              }
              final stream = filteredStreams[index - (liveStream != null ? 1 : 0)];
              return _buildStreamCard(theme, stream);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLiveStreamCard(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 10,
      child: InkWell(
        onTap: () {
          if (liveStream != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(title: Text(liveStream!['title']!)),
                  body: UniversalVideoPlayer(
                    videoUrl: liveStream!['url']!,
                    isEmbedded: false, // Fullscreen for streams
                  ),
                ),
              ),
            );
          }
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

  Widget _buildStreamCard(ThemeData theme, Map<String, String> stream) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      child: InkWell(
        onTap: () {
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
                        Icon(Icons.timer,
                            size: 16, color: theme.colorScheme.onSurface),
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
