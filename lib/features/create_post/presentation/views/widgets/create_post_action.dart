import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../../core/utils/app_colors.dart';

import 'create_post_action_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CreatePostActionButton(
          icon: Icons.image_rounded,
          label: 'Photo',
          color: Colors.green.shade600,
          onTap: _pickImage,
        ),
        CreatePostActionButton(
          icon: Icons.videocam_rounded,
          label: 'Vidéo',
          color: Colors.red.shade600,
          onTap: _pickVideo,
        ),
        CreatePostActionButton(
          icon: Icons.description_rounded,
          label: 'Fichier',
          color: Colors.blue.shade600,
          onTap: _pickFile,
        ),
      ],
    );
  }
}
