// lib/features/posts/presentation/views/widgets/media_widgets/image_viewer.dart
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  final String imageUrl;

  const ImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      ),
    );
  }
}