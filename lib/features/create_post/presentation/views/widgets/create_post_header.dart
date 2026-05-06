import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../auth/data/models/user_model.dart';

class CreatePostHeader extends StatelessWidget {
  final UserModel? user;

  const CreatePostHeader({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final name = user?.fullName ?? 'Utilisateur';
    final fonction = user?.function ?? (user?.role ?? 'Membre');
    final avatarUrl = user?.photoUrl;

    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColor.primary.withOpacity(0.1),
          backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
              ? NetworkImage(avatarUrl)
              : null,
          child: avatarUrl == null || avatarUrl.isEmpty
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: AppColor.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              : null,
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
