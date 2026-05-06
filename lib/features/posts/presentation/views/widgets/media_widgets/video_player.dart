// lib/features/posts/presentation/views/widgets/media_widgets/video_player.dart
import 'package:flutter/material.dart';

class VideoPlayer extends StatefulWidget {
  final String videoUrl;

  const VideoPlayer({super.key, required this.videoUrl});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: 250,
            color: Colors.black,
            child: const Center(
              child: Icon(Icons.play_circle_outline, color: Colors.white, size: 64),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: GestureDetector(
              onTap: () => setState(() => isPlaying = !isPlaying),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}