import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';

class CreatePostContent extends StatelessWidget {
  const CreatePostContent({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
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