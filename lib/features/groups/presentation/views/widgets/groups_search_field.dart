import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';

class GroupSearchField extends StatelessWidget {
  const GroupSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Rechercher un groupe...',
        hintStyle: TextStyle(
          color: AppColor.textHint,
          fontSize: 14,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: AppColor.textHint,
        ),
        filled: true,
        fillColor: AppColor.backgroundGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}