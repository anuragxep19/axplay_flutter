import 'package:flutter/material.dart';
import 'package:axplay/controller/video_controller.dart';
import 'package:axplay/view/play/widgets/player.dart';
import 'package:axplay/view/play/widgets/tool_bar.dart';
import 'package:provider/provider.dart';

class PlayView extends StatefulWidget {
  final int index;
  final String? title;
  const PlayView({super.key, required this.index, required this.title});

  @override
  State<PlayView> createState() => _PlayViewState();
}

class _PlayViewState extends State<PlayView> {
  late VideoController videoController;

  @override
  void initState() {
    super.initState();
    videoController = context.read<VideoController>();
    videoController.initializeVideo(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            videoController.playPauseVideo();
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: Text(widget.title ?? '', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent, // Making the AppBar transparent
        elevation: 0, // Removing AppBar shadow
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 39, 70, 248),
                Color.fromARGB(255, 41, 247, 243),
              ],
            ),
          ),
        ),
      ),

      body: Container(
        // Match the screen size
        width: double.infinity,
        height: double.infinity,
        // Apply the gradient decoration
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              Color.fromARGB(255, 39, 70, 248),
              Color.fromARGB(255, 41, 247, 243),
            ],
          ),
        ),
        child: Stack(
          children: [
            Player(),
            Align(alignment: Alignment.bottomCenter, child: ToolBar()),
          ],
        ),
      ),
    );
  }
}
