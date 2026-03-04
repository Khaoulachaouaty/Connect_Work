import 'package:connect_work/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class EditProfileAvatar extends StatelessWidget {
  const EditProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  // Changer photo
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            // Changer photo
          },
          child: Text(
            'Changer la photo',
            style: TextStyle(
              color: AppColor.primary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}