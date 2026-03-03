import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../../core/utils/app_colors.dart';

class CreatePostActions extends StatefulWidget {
  final Function(File file, String type) onFileSelected;

  const CreatePostActions({
    super.key,
    required this.onFileSelected,
  });

  @override
  State<CreatePostActions> createState() => _CreatePostActionsState();
}

class _CreatePostActionsState extends State<CreatePostActions> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        widget.onFileSelected(File(pickedFile.path), 'image');
      }
    } catch (e) {
      debugPrint('Erreur image: $e');
    }
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );

      if (pickedFile != null) {
        widget.onFileSelected(File(pickedFile.path), 'video');
      }
    } catch (e) {
      debugPrint('Erreur vidéo: $e');
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        widget.onFileSelected(file, 'file');
      }
    } catch (e) {
      debugPrint('Erreur fichier: $e');
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColor.primaryLight),
              title: const Text('Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam, color: AppColor.accentError),
              title: const Text('Vidéo'),
              onTap: () {
                Navigator.pop(context);
                _pickVideo();
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file, color: AppColor.accentSuccess),
              title: const Text('Fichier'),
              onTap: () {
                Navigator.pop(context);
                _pickFile();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionButton(
          icon: Icons.image_outlined,
          label: 'Photo',
          color: AppColor.primaryLight,
          onTap: _pickImage,
        ),
        const SizedBox(width: 24),
        _ActionButton(
          icon: Icons.videocam_outlined,
          label: 'Vidéo',
          color: AppColor.accentError,
          onTap: _pickVideo,
        ),
        const SizedBox(width: 24),
        _ActionButton(
          icon: Icons.insert_drive_file_outlined,
          label: 'Fichier',
          color: AppColor.accentSuccess,
          onTap: _pickFile,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}