import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connect_work/core/utils/app_colors.dart';
import 'package:connect_work/features/auth/data/models/user_model.dart';
import 'package:connect_work/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:connect_work/features/auth/presentation/cubit/auth_state.dart';
import 'package:connect_work/features/posts/data/models/post_media.dart';
import 'package:connect_work/features/posts/data/services/post_service.dart';
import 'package:connect_work/features/groups/data/models/group_modele.dart';

class PostPublishingService {
  static Future<void> publish({
    required BuildContext context,
    required Post? existingPost,
    required TextEditingController contentController,
    required File? selectedFile,
    required String? fileType,
    required String? selectedGroupId,
    required List<Group> userGroups,
    required UserModel? userModel,
    required PostService postService,
    required Function(String, {bool success}) showAlert,
  }) async {
    final content = contentController.text.trim();
    if (content.isEmpty) {
      showAlert('Veuillez saisir un contenu de publication.', success: false);
      return;
    }

    try {
      if (existingPost != null) {
        await postService.updatePost(existingPost.id, content);
        showAlert('Publication mise à jour !');
        if (context.mounted) context.pop();
        return;
      }

      if (userModel == null) {
        showAlert('Veuillez vous reconnecter pour publier.', success: false);
        return;
      }

      final targetMediaType = fileType == 'image'
          ? PostMediaType.image
          : fileType == 'video'
              ? PostMediaType.video
              : fileType == 'file' || fileType == 'pdf'
                  ? PostMediaType.pdf
                  : PostMediaType.none;

      String? mediaUrl;
      if (selectedFile != null && targetMediaType != PostMediaType.none) {
        mediaUrl = await postService.uploadMedia(selectedFile, targetMediaType, userModel.uid);
      }

      final selectedGroup = selectedGroupId != null 
          ? userGroups.firstWhere((g) => g.id == selectedGroupId)
          : null;

      final post = Post(
        id: '',
        authorId: userModel.uid,
        authorName: userModel.fullName,
        authorRole: userModel.function?.isNotEmpty == true
            ? userModel.function!
            : userModel.role,
        authorAvatar: userModel.photoUrl ?? '',
        content: content,
        createdAt: DateTime.now(),
        mediaType: targetMediaType,
        mediaUrl: mediaUrl,
        fileName: fileType == 'file' ? selectedFile?.path.split('/').last : null,
        groupId: selectedGroup?.id,
        groupName: selectedGroup?.name,
      );

      await postService.createPost(post);
      showAlert('Publication enregistrée !');
      if (context.mounted) context.pop();
    } catch (e) {
      showAlert('Erreur : $e', success: false);
    }
  }
}
