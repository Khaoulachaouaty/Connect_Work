import 'package:flutter/material.dart';

class PostContent extends StatelessWidget {
  const PostContent({super.key, required String content});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Excellente réunion ce matin ! Notre nouveau projet prend forme. Hâte de voir les résultats 🚀',
        style: TextStyle(
          fontSize: 14,
          height: 1.4,
        ),
      ),
    );
  }
}