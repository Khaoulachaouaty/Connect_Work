import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';

class ProfileAppBar extends StatelessWidget {
  final VoidCallback? onEditTap;

  const ProfileAppBar({super.key, this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      floating: false,
      elevation: 0,
      backgroundColor: AppColor.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColor.primary,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 40),
          child: GestureDetector(
            onTap: onEditTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.settings_outlined,
                    size: 16,
                    color: AppColor.textPrimary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Modifier',
                    style: TextStyle(
                      color: AppColor.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}