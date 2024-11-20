import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// A universal video player that adapts based on the video source.
class UniversalVideoPlayer extends StatefulWidget {
  final String videoUrl; // The URL of the video
  final bool isEmbedded; // Whether the player is embedded or fullscreen

  const UniversalVideoPlayer({
    required this.videoUrl,
    this.isEmbedded = true,
    Key? key,
  }) : super(key: key);

  @override
  _UniversalVideoPlayerState createState() => _UniversalVideoPlayerState();
}

class _UniversalVideoPlayerState extends State<UniversalVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  YoutubePlayerController? _youtubeController;
  bool isYoutubeVideo = false;

  @override
  void initState() {
    super.initState();
    _determineVideoType();
  }

  /// Determines whether the video URL is for YouTube or another format.
  void _determineVideoType() {
    final youtubeId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (youtubeId != null) {
      isYoutubeVideo = true;
      _initializeYoutubePlayer(youtubeId);
    } else {
      _initializeChewiePlayer();
    }
  }

  /// Initializes the YouTube player with the extracted YouTube ID.
  void _initializeYoutubePlayer(String youtubeId) {
    _youtubeController = YoutubePlayerController(
      initialVideoId: youtubeId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    setState(() {});
  }

  /// Initializes the Chewie player for non-YouTube videos.
  Future<void> _initializeChewiePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: !widget.isEmbedded, // Autoplay if fullscreen
        looping: false,
        showControls: true,
      );
      setState(() {});
    } catch (e) {
      print('Error initializing Chewie player: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isYoutubeVideo) {
      return _buildYoutubePlayer();
    } else {
      return _buildChewiePlayer();
    }
  }

  /// Builds the YouTube player widget.
  Widget _buildYoutubePlayer() {
    final theme = Theme.of(context);
    if (_youtubeController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: YoutubePlayer(
          controller: _youtubeController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: theme.colorScheme.secondary,
        ),
      ),
    );
  }

  /// Builds the Chewie player widget for non-YouTube videos.
  Widget _buildChewiePlayer() {
    return _chewieController != null &&
            _videoPlayerController.value.isInitialized
        ? AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: Chewie(controller: _chewieController!),
          )
        : const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    if (!isYoutubeVideo) {
      _videoPlayerController.dispose();
      _chewieController?.dispose();
    } else {
      _youtubeController?.dispose();
    }
    super.dispose();
  }
}
