import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connect_work/core/services/service_locator.dart';
import 'package:connect_work/core/utils/app_colors.dart';
import 'package:connect_work/features/auth/data/models/user_model.dart';
import 'package:connect_work/features/auth/data/services/auth_service.dart';
import 'package:connect_work/features/groups/data/models/group_modele.dart';
import 'package:connect_work/features/groups/data/services/group_service.dart';
import 'package:connect_work/features/posts/data/models/post_media.dart';
import 'package:connect_work/features/posts/data/services/post_service.dart';
import 'widgets/create_post_app_bar.dart';
import 'widgets/create_post_body.dart';
import 'widgets/post_publishing_service.dart';

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
    setState(() => _isPublishing = true);
    await PostPublishingService.publish(
      context: context,
      existingPost: widget.existingPost,
      contentController: _contentController,
      selectedFile: selectedFile,
      fileType: fileType,
      selectedGroupId: _selectedGroupId,
      userGroups: _userGroups,
      userModel: _userModel,
      postService: _postService,
      showAlert: _showBottomAlert,
    );
    if (mounted) setState(() => _isPublishing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CreatePostAppBar(onPublish: _publishPost),
      body: _isLoadingUser || _isPublishing
          ? const Center(child: CircularProgressIndicator())
          : CreatePostBody(
              userModel: _userModel,
              contentController: _contentController,
              selectedFile: selectedFile,
              fileType: fileType,
              selectedGroupId: _selectedGroupId,
              userGroups: _userGroups,
              onFileSelected: _onFileSelected,
              onRemoveFile: _removeFile,
              onGroupChanged: (val) => setState(() => _selectedGroupId = val),
            ),
    );
  }
}
