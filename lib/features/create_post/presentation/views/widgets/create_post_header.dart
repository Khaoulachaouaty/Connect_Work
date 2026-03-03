import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';

class CreatePostHeader extends StatelessWidget {
  const CreatePostHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sarah Martinez',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              'Product Manager',
              style: TextStyle(
                color: AppColor.iconPrimary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}