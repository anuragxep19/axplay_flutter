import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:axplay/model/video_model.dart';
import 'package:axplay/utils/permission_manager.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

final List<String> videoPaths = [
  'assets/videos/mountain_range.mp4',
  'assets/videos/sea.mp4',
  'assets/videos/sky.mp4',
  'assets/videos/sun_rise.mp4',
  'assets/videos/mountain_range.mp4',
  'assets/videos/sea.mp4',
  'assets/videos/sky.mp4',
  'assets/videos/sun_rise.mp4',
  'assets/videos/mountain_range.mp4',
  'assets/videos/sea.mp4',
  'assets/videos/sky.mp4',
  'assets/videos/sun_rise.mp4',
];

const Duration _skipTime = Duration(seconds: 10);

class VideoController extends ChangeNotifier {
  final IVideoCompress _videoCompress = VideoCompress;
  final PermissionManager _permissionsState = PermissionManager();
  final mediaStore = MediaStore();
  final List<VideoModel> _videos = [];
  late VideoModel _currentVideo;
  int _currentIndex = 0;
  bool _isFullScreen = false;
  final bool _isPermissionGranted = false;

  List<VideoModel> get videos => _videos;
  VideoPlayerController get controller => _currentVideo.controller;
  VideoPlayerValue get controllerValue => controller.value;

  bool get isPlaying => controllerValue.isPlaying;
  bool get isFullScreen => _isFullScreen;
  bool get isPermissionGranted => _isPermissionGranted;
  String get position => _formatDuration(duration: controllerValue.position);
  String get duration => _formatDuration(duration: controllerValue.duration);
  double get sliderValue {
    final sliderValue =
        controllerValue.position.inMilliseconds.toDouble() /
        controllerValue.duration.inMilliseconds.toDouble();
    return sliderValue.isNaN ? 0 : sliderValue;
  }

  String get remaining {
    final remaining = (controllerValue.duration - controllerValue.position);
    return _formatDuration(duration: remaining);
  }

  /// Load and prepare all video models
  Future<List<VideoModel>> loadVideos(BuildContext context) async {
    await _permissionsState.ensureAllPermissionsGranted(context);

    if (!_permissionsState.storagePermissionStatus.isGranted ||
        !_permissionsState.cameraPermissionStatus.isGranted) {
      return [];
    }
    _videos.clear();

    for (var path in videoPaths) {
      final List mediaInfo = await _getMediaInfo(path);

      _videos.add(
        VideoModel(
          type: VideoType.asset,
          videoUrl: path,
          thumbnail: mediaInfo[0],
          duration: _formatDuration(
            milliseconds: mediaInfo[1].duration.toInt() ?? 0,
          ),
          title: _extractTitle(path),
        ),
      );
    }
    final List<AssetPathEntity> videoAlbums =
        await PhotoManager.getAssetPathList(type: RequestType.video);

    for (final album in videoAlbums) {
      final List<AssetEntity> videos = await album.getAssetListPaged(
        page: 0,
        size: await album.assetCountAsync,
      );
      for (final video in videos) {
        //TODO: Access local file info
        var path = (await video.file);
        if (path != null) {
          _videos.add(VideoModel(videoUrl: path.path, type: VideoType.file));
        }
      }
    }

    return videos;
  }

  /// Initialize selected video by index
  Future<void> initializeVideo(int index) async {
    _currentIndex = index;
    _currentVideo = _videos[_currentIndex];
    await _currentVideo.initialize().then((value) {
      playPauseVideo();
      _currentVideo.controller.addListener(notifyListeners);
    });
  }

  void playPauseVideo() =>
      isPlaying ? _currentVideo.pause() : _currentVideo.play();

  void seekTo(double position) => _currentVideo.seekTo(position);

  void replay() => _currentVideo.replay(_skipTime);

  void forward() => _currentVideo.forward(_skipTime);

  Future<void> skipPrevious() async {
    if (_currentIndex > 0) {
      await _switchVideo(_currentIndex - 1);
    }
  }

  Future<void> skipNext() async {
    if (_currentIndex < _videos.length - 1) {
      await _switchVideo(_currentIndex + 1);
    }
  }

  Future<void> _switchVideo(int newIndex) async {
    playPauseVideo();
    await initializeVideo(newIndex);
  }

  void fullscreenToggle() {
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    _isFullScreen = !_isFullScreen;
  }

  @override
  void dispose() {
    _currentVideo.dispose();
    super.dispose();
  }

  // ---------- Helpers ----------
  Future<List<dynamic>> _getMediaInfo(String videoPath, {File? file}) async {
    if (file == null) {
      final copiedPath = await _copyAssetToFile(videoPath);
      final thumbnail = await _videoCompress.getFileThumbnail(copiedPath);
      final mediaInfo = await _videoCompress.getMediaInfo(copiedPath);

      return [thumbnail, mediaInfo];
    }
    return [];
  }

  Future<String> _copyAssetToFile(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final fileName = assetPath.split('/').last;
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file.path;
  }

  String _extractTitle(String path) {
    final name = path.split('/').last;
    return name.replaceAll('.mp4', '').replaceAll('_', ' ').toTitleCase();
  }

  String _formatDuration({int? milliseconds, Duration? duration}) {
    if (milliseconds == null && duration == null) {
      throw ArgumentError('At least one argument (a or b) must be provided.');
    }
    duration = duration ?? Duration(milliseconds: milliseconds ?? 0);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

extension TitleCase on String {
  String toTitleCase() {
    return split(' ')
        .map(
          (word) =>
              word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                  : '',
        )
        .join(' ');
  }
}
