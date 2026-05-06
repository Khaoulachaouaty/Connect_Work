import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connect_work/core/utils/app_colors.dart';
import 'package:connect_work/features/auth/data/models/user_model.dart';
import 'package:connect_work/features/groups/data/models/group_modele.dart';
import 'create_post_header.dart';
import 'create_post_group_selector.dart';
import 'create_post_content.dart';
import 'selectd_file_preview.dart';
import 'create_post_visibility.dart';
import 'create_post_action.dart';

class CreatePostBody extends StatelessWidget {
  final UserModel? userModel;
  final TextEditingController contentController;
  final File? selectedFile;
  final String? fileType;
  final String? selectedGroupId;
  final List<Group> userGroups;
  final Function(File, String) onFileSelected;
  final VoidCallback onRemoveFile;
  final ValueChanged<String?> onGroupChanged;

  const CreatePostBody({
    super.key,
    required this.userModel,
    required this.contentController,
    required this.selectedFile,
    required this.fileType,
    required this.selectedGroupId,
    required this.userGroups,
    required this.onFileSelected,
    required this.onRemoveFile,
    required this.onGroupChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CreatePostHeader(user: userModel),
                const SizedBox(height: 12),
                CreatePostGroupSelector(
                  selectedGroupId: selectedGroupId,
                  userGroups: userGroups,
                  onChanged: onGroupChanged,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CreatePostContent(controller: contentController),
          ),
          if (selectedFile != null) ...[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SelectedFilePreview(
                file: selectedFile!,
                fileType: fileType!,
                onRemove: onRemoveFile,
              ),
            ),
          ],
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CreatePostVisibility(),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: CreatePostActions(onFileSelected: onFileSelected),
          ),
        ],
      ),
    );
  }
}
