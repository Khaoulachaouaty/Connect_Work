import 'dart:io';
import 'package:connect_work/core/services/service_locator.dart';
import 'package:connect_work/features/auth/data/models/user_model.dart';
import 'package:connect_work/features/auth/data/services/auth_service.dart';
import 'package:connect_work/features/posts/data/models/post_media.dart';
import 'package:connect_work/features/posts/data/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  final TextEditingController _contentController = TextEditingController();
  final PostService _postService = getIt<PostService>();
  final AuthService _authService = getIt<AuthService>();
  UserModel? _userModel;
  bool _isLoadingUser = true;
  bool _isPublishing = false;

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
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await _authService.getCurrentUserData();
      setState(() {
        _userModel = user;
        _isLoadingUser = false;
      });
    } catch (e) {
      setState(() {
        _userModel = null;
        _isLoadingUser = false;
      });
    }
  }

  void _showBottomAlert(String message, {bool success = true}) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      backgroundColor: success ? AppColor.accentSuccess : AppColor.accentError,
      content: Text(
        message,
        style: const TextStyle(fontSize: 14, color: AppColor.white),
      ),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _publishPost() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      _showBottomAlert('Veuillez saisir un contenu de publication.', success: false);
      return;
    }

    setState(() {
      _isPublishing = true;
    });

    final userModel = _userModel ?? await _authService.getCurrentUserData();
    final currentUser = _authService.currentUser;
    if (userModel == null || currentUser == null) {
      _showBottomAlert('Veuillez vous reconnecter pour publier.', success: false);
      setState(() {
        _isPublishing = false;
      });
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
      try {
        mediaUrl = await _postService.uploadMedia(selectedFile!, targetMediaType, currentUser.uid);
      } catch (e) {
        _showBottomAlert('Erreur upload média : $e', success: false);
        setState(() {
          _isPublishing = false;
        });
        return;
      }
    }

    final post = Post(
      id: '',
      authorId: currentUser.uid,
      authorName: userModel.name,
      authorRole: userModel.function?.isNotEmpty == true
          ? userModel.function!
          : userModel.role,
      authorAvatar: userModel.photoUrl ?? '',
      content: content,
      createdAt: DateTime.now(),
      mediaType: targetMediaType,
      mediaUrl: mediaUrl,
      fileName: fileType == 'file' ? selectedFile?.path.split('/').last : null,
    );

    try {
      await _postService.createPost(post);
      _showBottomAlert('Publication enregistrée !');
      context.pop();
    } catch (e) {
      _showBottomAlert('Erreur création post : $e', success: false);
    } finally {
      setState(() {
        _isPublishing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CreatePostAppBar(onPublish: _publishPost),
      body: _isLoadingUser
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CreatePostHeader(user: _userModel),
                  const SizedBox(height: 20),
                  CreatePostContent(controller: _contentController),

                  if (selectedFile != null) ...[
                    const SizedBox(height: 20),
                    SelectedFilePreview(
                      file: selectedFile!,
                      fileType: fileType!,
                      onRemove: _removeFile,
                    ),
                  ],

                  const SizedBox(height: 20),
                  const CreatePostVisibility(),
                  const SizedBox(height: 20),
                  CreatePostActions(onFileSelected: _onFileSelected),
                ],
              ),
            ),
    );
  }
}
