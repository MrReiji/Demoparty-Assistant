import 'package:demoparty_assistant/constants/Theme.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoWidget extends StatelessWidget {
  final String videoId;

  const YoutubeVideoWidget({required this.videoId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: AppDimensions.paddingMedium - AppDimensions.paddingSmall,
      ),
      padding: EdgeInsets.all(AppDimensions.paddingSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: AppDimensions.shadowBlurRadius,
            offset: AppOffsets.shadowOffset,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        child: YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
