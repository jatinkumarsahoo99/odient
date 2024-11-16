import 'package:dtcameo/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayPause extends StatelessWidget {
  const VideoPlayPause({super.key, required this.controller});
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 50),
      reverseDuration: const Duration(milliseconds: 200),
      child: controller.value.isPlaying
          ? const SizedBox(
              height: 60,
              width: 60,
            )
          : Container(
              height: 60,
              width: 60,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: colorAccent),
              child: const Icon(
                Icons.play_arrow,
                size: 20,
                color: colorPrimaryDark,
              ),
            ),
    );
  }
}
