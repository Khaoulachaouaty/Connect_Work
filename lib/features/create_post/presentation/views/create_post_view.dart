import 'dart:io';
import 'package:connect_work/core/services/service_locator.dart';
import 'package:connect_work/features/auth/data/models/user_model.dart';
import 'package:connect_work/features/auth/data/services/auth_service.dart';
import 'package:connect_work/features/posts/data/models/post_media.dart';
import 'package:connect_work/features/posts/data/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../groups/data/models/group_modele.dart';
import 'widgets/create_post_action.dart';
import 'widgets/create_post_app_bar.dart';
import 'widgets/create_post_header.dart';
import 'widgets/create_post_content.dart';
import 'widgets/create_post_visibility.dart';
import 'widgets/selectd_file_preview.dart';
import '../../../groups/data/services/group_service.dart';
import '../../../groups/data/models/group_modele.dart';

class CreatePostView extends StatefulWidget {
  final Group? initialGroup;
  final Post? existingPost;
  const CreatePostView({super.key, this.initialGroup, this.existingPost});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  File? selectedFile;
  String? fileType;
  final TextEditingController _contentController = TextEditingController();
  final PostService _postService = getIt<PostService>();
  final AuthService _authService = getIt<AuthService>();
  final GroupService _groupService = GroupService();
  UserModel? _userModel;
  List<Group> _userGroups = [];
  String? _selectedGroupId;
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
    if (widget.existingPost != null) {
      _contentController.text = widget.existingPost!.content;
      _selectedGroupId = widget.existingPost!.groupId;
    }
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final user = await _authService.getCurrentUser();
      List<Group> groups = [];
      if (user != null) {
        groups = await _groupService.getUserGroups(user.uid);
      }
      setState(() {
        _userModel = user;
        _userGroups = groups;
        if (widget.initialGroup != null && _userGroups.any((g) => g.id == widget.initialGroup!.id)) {
          _selectedGroupId = widget.initialGroup!.id;
        }
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

    try {
      if (widget.existingPost != null) {
        await _postService.updatePost(widget.existingPost!.id, content);
        _showBottomAlert('Publication mise à jour !');
        context.pop();
        return;
      }

      final userModel = _userModel ?? await _authService.getCurrentUser();
      final currentUser = _authService.currentUser;
      if (userModel == null || currentUser == null) {
        _showBottomAlert('Veuillez vous reconnecter pour publier.', success: false);
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
        mediaUrl = await _postService.uploadMedia(selectedFile!, targetMediaType, currentUser.uid);
      }

      final selectedGroup = _selectedGroupId != null 
          ? _userGroups.firstWhere((g) => g.id == _selectedGroupId)
          : null;

      final post = Post(
        id: '',
        authorId: currentUser.uid,
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

      await _postService.createPost(post);
      _showBottomAlert('Publication enregistrée !');
      context.pop();
    } catch (e) {
      _showBottomAlert('Erreur : $e', success: false);
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
                        CreatePostHeader(user: _userModel),
                        const SizedBox(height: 12),
                        _buildGroupSelector(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CreatePostContent(controller: _contentController),
                  ),

                  if (selectedFile != null) ...[
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SelectedFilePreview(
                        file: selectedFile!,
                        fileType: fileType!,
                        onRemove: _removeFile,
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const CreatePostVisibility(),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: CreatePostActions(onFileSelected: _onFileSelected),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildGroupSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: _selectedGroupId,
          hint: const Text('Sélectionner un groupe (Optionnel)', style: TextStyle(fontSize: 12)),
          icon: const Icon(Icons.arrow_drop_down, size: 18),
          onChanged: (String? newValue) {
            setState(() {
              _selectedGroupId = newValue;
            });
          },
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text('Fil d\'actualité public', style: TextStyle(fontSize: 12)),
            ),
            ..._userGroups.map((Group group) {
              return DropdownMenuItem<String?>(
                value: group.id,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.groups_rounded, size: 16, color: AppColor.primary),
                    const SizedBox(width: 8),
                    Text(group.name, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
