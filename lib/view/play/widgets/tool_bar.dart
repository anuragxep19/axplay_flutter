import 'package:flutter/material.dart';
import 'package:axplay/controller/video_controller.dart';
import 'package:axplay/utils/responsive.dart';
import 'package:axplay/view/play/fullscreen_view.dart';
import 'package:provider/provider.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: context.isLandscape ? 0.45.s : 0.25.s,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.s, vertical: 8.s),
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.3),
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.s)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_Slider(), _Buttons()],
        ),
      ),
    );
  }
}

class _Slider extends StatelessWidget {
  final ValueNotifier isTaped = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final videoController = context.watch<VideoController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Current Position Text
        Text(
          videoController.position,
          style: TextStyle(color: Colors.white, fontSize: 14.s),
        ),

        // Slider
        Expanded(
          child: Slider(
            value: videoController.sliderValue,
            onChanged: (value) => videoController.seekTo(value),
            activeColor: const Color.fromARGB(255, 33, 72, 243),
            inactiveColor: Colors.grey[50],
          ),
        ),

        // Duration / Remaining Time Toggle Button
        ValueListenableBuilder(
          valueListenable: isTaped,
          builder: (context, value, child) {
            return TextButton(
              onPressed: () => isTaped.value = !value,
              child: Text(
                isTaped.value
                    ? "-${videoController.remaining}"
                    : " ${videoController.duration}",
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Buttons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VideoController videoController = context.watch<VideoController>();

    final isFullScreen = videoController.isFullScreen;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () async => videoController.skipPrevious(),
          icon: Icon(Icons.skip_previous, size: 40.s, color: Colors.white),
        ),
        IconButton(
          onPressed: () => videoController.replay(),
          icon: Icon(Icons.replay_10, size: 40.s, color: Colors.white),
        ),
        IconButton(
          onPressed: () => videoController.playPauseVideo(),
          icon: Icon(
            videoController.isPlaying ? Icons.pause : Icons.play_arrow,
            size: 50.s,
            color: const Color.fromARGB(
              255,
              0,
              46,
              250,
            ), // More prominent color
          ),
        ),
        IconButton(
          onPressed: () {
            videoController.forward();
          },
          icon: Icon(Icons.forward_10, size: 40.s, color: Colors.white),
        ),
        IconButton(
          onPressed: () async => videoController.skipNext(),
          icon: Icon(Icons.skip_next, size: 40.s, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            isFullScreen
                ? Navigator.pop(context)
                : Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FullscreenView()),
                );
          },
          icon: Icon(
            isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
            size: 40.s,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
