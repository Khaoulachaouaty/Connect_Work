import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';

class CreatePostVisibility extends StatefulWidget {
  const CreatePostVisibility({super.key});

  @override
  State<CreatePostVisibility> createState() => _CreatePostVisibilityState();
}

class _CreatePostVisibilityState extends State<CreatePostVisibility> {
  bool isPublic = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'VISIBILITÉ',
          style: TextStyle(
            color: AppColor.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _VisibilityButton(
                icon: Icons.public,
                label: 'Public',
                isSelected: isPublic,
                onTap: () => setState(() => isPublic = true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _VisibilityButton(
                icon: Icons.people_outline,
                label: 'Groupe',
                isSelected: !isPublic,
                onTap: () => setState(() => isPublic = false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VisibilityButton extends StatelessWidget {
  const _VisibilityButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primary.withOpacity(0.1) : AppColor.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColor.primary : AppColor.textSecondary,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColor.primary : AppColor.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColor.primary : AppColor.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}