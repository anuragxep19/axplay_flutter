import 'package:flutter/material.dart';
import 'package:axplay/controller/video_controller.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class Player extends StatelessWidget {
  const Player({super.key});

  @override
  Widget build(BuildContext context) {
    final videoPlayer = context.watch<VideoController>().controller;
    return Center(
      child:
          videoPlayer.value.isInitialized
              ? AspectRatio(
                aspectRatio: videoPlayer.value.aspectRatio,
                child: VideoPlayer(videoPlayer),
              )
              : const CircularProgressIndicator(),
    );
  }
}
