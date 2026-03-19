import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../auth/data/models/user_model.dart';

class CreatePostHeader extends StatelessWidget {
  final UserModel? user;

  const CreatePostHeader({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final name = user?.name ?? 'Utilisateur inconnu';
    final fonction = user?.function ?? 'Fonction inconnue';
    final avatarUrl = user?.photoUrl?.isNotEmpty == true
        ? user!.photoUrl!
        : 'https://i.pravatar.cc/150?img=5';

    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColor.textPrimary,
              ),
            ),
            Text(
              fonction,
              style: const TextStyle(
                color: AppColor.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
