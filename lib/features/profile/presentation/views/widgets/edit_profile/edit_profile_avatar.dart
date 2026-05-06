import 'package:connect_work/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../../auth/data/models/user_model.dart';

class EditProfileAvatar extends StatelessWidget {
  final UserModel user;
  const EditProfileAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 64,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue.shade50,
                  backgroundImage: user.photoUrl != null && user.photoUrl!.isNotEmpty
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null || user.photoUrl!.isEmpty
                      ? Text(
                          user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  // Changer photo
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: const Text('Changer la photo'),
          style: TextButton.styleFrom(
            foregroundColor: AppColor.primary,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}