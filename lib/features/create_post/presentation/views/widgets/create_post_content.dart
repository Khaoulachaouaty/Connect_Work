import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';

class CreatePostContent extends StatelessWidget {
  final TextEditingController controller;

  const CreatePostContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: null,
      minLines: 8,
      style: const TextStyle(
        fontSize: 18,
        color: AppColor.textPrimary,
        height: 1.5,
      ),
      decoration: InputDecoration(
        hintText: 'Partagez vos idées ou vos succès...',
        hintStyle: TextStyle(
          color: AppColor.textHint.withOpacity(0.6),
          fontSize: 18,
          fontStyle: FontStyle.italic,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}