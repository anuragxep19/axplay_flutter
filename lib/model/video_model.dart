import 'dart:io';
import 'package:video_player/video_player.dart';

enum VideoType { asset, network, file }

class VideoModel {
  final String videoUrl;
  final File? thumbnail;
  final String? title;
  final String? duration;
  final VideoType type;
  late final VideoPlayerController _controller;

  VideoModel({
    required this.videoUrl,
    required this.type,
    this.thumbnail,
    this.title,
    this.duration,
  }) {
    _controller = initVideo(type, videoUrl);
  }

  VideoPlayerController get controller => _controller;

  /// Initializes the player.
  Future<void> initialize() => _controller.initialize();

  /// Playback Controls
  void play() => _controller.play();
  void pause() => _controller.pause();

  void seekTo(double position) {
    final duration = _controller.value.duration.inMilliseconds;
    final seekPosition = (position * duration).toInt();
    _controller.seekTo(Duration(milliseconds: seekPosition));
  }

  void replay(Duration skip) {
    final newPosition = _controller.value.position - skip;
    _controller.seekTo(
      newPosition >= Duration.zero ? newPosition : Duration.zero,
    );
  }

  void forward(Duration skip) {
    final newPosition = _controller.value.position + skip;
    final maxDuration = _controller.value.duration;
    _controller.seekTo(newPosition <= maxDuration ? newPosition : maxDuration);
  }

  /// Cleanup
  void dispose() => _controller.dispose();
}

VideoPlayerController initVideo(VideoType type, videoUrl) {
  switch (type) {
    case VideoType.asset:
      return VideoPlayerController.asset(videoUrl);
    case VideoType.network:
      return VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    case VideoType.file:
      return VideoPlayerController.file(File(videoUrl));
  }
}
