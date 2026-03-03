import 'dart:io';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';

class SelectedFilePreview extends StatelessWidget {
  final File file;
  final String fileType;
  final VoidCallback onRemove;

  const SelectedFilePreview({
    super.key,
    required this.file,
    required this.fileType,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.white),
          ),
          child: _buildPreview(),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColor.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: AppColor.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    switch (fileType) {
      case 'image':
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            file,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
        );
      case 'video':
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.videocam,
                size: 64,
                color: AppColor.backgroundGrey,
              ),
              const SizedBox(height: 8),
              Text(
                'Vidéo sélectionnée',
                style: TextStyle(color: AppColor.textSecondary),
              ),
              Text(
                file.path.split('/').last,
                style: TextStyle(
                  color: AppColor.textSecondary,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      case 'file':
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insert_drive_file,
                size: 64,
                color: AppColor.backgroundGrey,
              ),
              const SizedBox(height: 8),
              Text(
                'Fichier sélectionné',
                style: TextStyle(color: AppColor.textSecondary),
              ),
              Text(
                file.path.split('/').last,
                style: TextStyle(
                  color: AppColor.textSecondary,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}