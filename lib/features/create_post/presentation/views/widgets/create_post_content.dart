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
      minLines: 5,
      decoration: InputDecoration(
        hintText: 'Quoi de neuf ?',
        hintStyle: TextStyle(
          color: AppColor.textHint,
          fontSize: 16,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}