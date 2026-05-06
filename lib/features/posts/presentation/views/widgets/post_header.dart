import 'package:connect_work/core/services/service_locator.dart';
import 'package:connect_work/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:connect_work/features/auth/presentation/cubit/auth_state.dart';
import 'package:connect_work/features/posts/data/models/post_media.dart';
import 'package:connect_work/features/posts/data/services/post_service.dart';
import 'package:connect_work/features/messages/data/services/chat_service.dart';
import 'package:connect_work/features/messages/data/models/chat_room_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({super.key, required this.post});

  final Post post;

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours} h';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays} j';
    return 'Le ${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final userId = authState is AuthAuthenticated ? authState.user.uid : '';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _startDirectChat(context, userId),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue.shade50,
              backgroundImage: post.authorAvatar.isNotEmpty
                  ? NetworkImage(post.authorAvatar)
                  : null,
              child: post.authorAvatar.isEmpty
                  ? Text(
                      post.authorName.isNotEmpty ? post.authorName[0].toUpperCase() : 'U',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => _startDirectChat(context, userId),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.authorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '${post.authorRole} • ${_formatTimeAgo(post.createdAt)}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (post.authorId == userId)
            PopupMenuButton<String>(
              onSelected: (value) => _onMenuSelected(context, value),
              icon: const Icon(Icons.more_horiz),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text('Modifier'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Supprimer', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _onMenuSelected(BuildContext context, String value) {
    if (value == 'delete') {
      _showDeleteDialog(context);
    } else if (value == 'edit') {
      context.push('/create-post', extra: post);
    }
  }

  void _startDirectChat(BuildContext context, String currentUserId) async {
    if (currentUserId == post.authorId) return;

    final roomId = await getIt<ChatService>().getOrCreateDirectChat(
      currentUserId,
      post.authorId,
      otherUserName: post.authorName,
      otherUserAvatar: post.authorAvatar,
    );

    if (context.mounted) {
      context.push('/chat-room', extra: ChatRoom(
        id: roomId,
        name: post.authorName,
        avatar: post.authorAvatar,
        participants: [currentUserId, post.authorId],
        lastMessageTime: DateTime.now(),
      ));
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la publication ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              await getIt<PostService>().deletePost(post.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}