import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import 'widgets/create_post_action.dart';
import 'widgets/create_post_app_bar.dart';
import 'widgets/create_post_header.dart';
import 'widgets/create_post_content.dart';
import 'widgets/create_post_visibility.dart';
import 'widgets/selectd_file_preview.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  File? selectedFile;
  String? fileType;

  void _onFileSelected(File file, String type) {
    setState(() {
      selectedFile = file;
      fileType = type;
    });
  }

  void _removeFile() {
    setState(() {
      selectedFile = null;
      fileType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: const CreatePostAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CreatePostHeader(),
            const SizedBox(height: 20),
            const CreatePostContent(),
            
            // Aperçu du fichier sélectionné
            if (selectedFile != null) ...[
              const SizedBox(height: 20),
              SelectedFilePreview(
                file: selectedFile!,
                fileType: fileType!,
                onRemove: _removeFile,
              ),
            ],
            
            const SizedBox(height: 400),
            const CreatePostVisibility(),
            const SizedBox(height: 20),
            CreatePostActions(onFileSelected: _onFileSelected),
          ],
        ),
      ),
    );
  }
}