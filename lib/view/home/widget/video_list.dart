import 'package:flutter/material.dart';
import 'package:axplay/controller/video_controller.dart';
import 'package:axplay/model/video_model.dart';
import 'package:axplay/utils/responsive.dart';
import 'package:axplay/view/play/play_view.dart';
import 'package:axplay/view/home/widget/glass_container.dart';
import 'package:provider/provider.dart';

class VideoList extends StatelessWidget {
  const VideoList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<VideoController>().loadVideos(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            // ),
          );
        }

        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final videoList = snapshot.data as List<VideoModel>;

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return _VideoTile(videos: videoList, currentIndex: index);
          }, childCount: videoList.length),
        );
      },
    );
  }
}

class _VideoTile extends StatelessWidget {
  final List<VideoModel> videos;
  final int currentIndex;
  const _VideoTile({required this.videos, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final video = videos[currentIndex];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.s, horizontal: 15.s),
      child: GlassWidget(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            PlayView(index: currentIndex, title: video.title),
                  ),
                ),
            child: ListTile(
              contentPadding: EdgeInsets.all(5),
              tileColor: Colors.transparent,
              leading: _Thumbnail(video: video),
              title: Text(
                overflow: TextOverflow.ellipsis,
                video.title ?? 'No Title',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.video});

  final VideoModel video;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        video.thumbnail != null
            ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(width: 100.s, height: 50.s, video.thumbnail!),
            )
            : Container(
              margin: EdgeInsets.only(left: 8, right: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(3),
              ),
              width: 90.s,
              height: 50.s,
            ),
        Positioned.fill(
          child: Icon(Icons.play_arrow_sharp, size: 30, color: Colors.white),
        ),
        if (video.duration != null)
          Positioned(
            right: 5.s,
            bottom: 0.s,
            child: Container(
              width: 40.s,
              height: 20.s,
              decoration: BoxDecoration(color: Colors.black),
              child: Center(
                child: Text(
                  video.duration ?? '',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
