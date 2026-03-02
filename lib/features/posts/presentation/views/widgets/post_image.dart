import 'package:flutter/material.dart';

class PostImage extends StatelessWidget {
  const PostImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=600',
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}