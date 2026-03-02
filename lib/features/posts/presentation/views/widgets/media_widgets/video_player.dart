import 'package:flutter/material.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Thumbnail
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: 250,
            color: Colors.black,
            child: const Center(
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 64,
              ),
            ),
          ),
        ),
        // Play button
        Positioned.fill(
          child: Center(
            child: GestureDetector(
              onTap: () => setState(() => isPlaying = !isPlaying),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
        // Bouton télécharger
        Positioned(
          top: 8,
          right: 8,
          child: _DownloadButton(
            url: widget.videoUrl,
            fileName: 'video_${DateTime.now().millisecondsSinceEpoch}.mp4',
          ),
        ),
        // Durée (optionnel)
        Positioned(
          bottom: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '2:45',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class _DownloadButton extends StatelessWidget {
  const _DownloadButton({required this.url, required this.fileName});

  final String url;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Téléchargement de $fileName...')),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.download,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}