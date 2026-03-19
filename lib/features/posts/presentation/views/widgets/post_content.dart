import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';

class PostContent extends StatelessWidget {
  const PostContent({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 14,
          height: 1.4,
          color: AppColor.textPrimary,
        ),
      ),
    );
  }
}