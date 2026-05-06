import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';

class PostContent extends StatelessWidget {
  const PostContent({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 15,
          height: 1.5,
          color: Color(0xFF334155),
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}