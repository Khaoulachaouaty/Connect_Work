import 'package:flutter/material.dart';

import '../download_button.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: DownloadButton(
            url: imageUrl,
            fileName: 'image_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        ),
      ],
    );
  }
}