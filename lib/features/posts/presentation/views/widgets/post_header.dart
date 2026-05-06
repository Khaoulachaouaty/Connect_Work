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

import '../../../../../core/widgets/user_avatar.dart';

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
    final isMe = post.authorId == userId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          UserAvatar(
            imageUrl: post.authorAvatar,
            name: post.authorName,
            radius: 20,
            showBorder: true,
            onTap: () => _startDirectChat(context, userId),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => _startDirectChat(context, userId),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Color(0xFF1E293B),
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (!isMe) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.chat_bubble_rounded, size: 12, color: Colors.blue.shade300),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${post.authorRole} • ${_formatTimeAgo(post.createdAt)}',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe)
            IconButton(
              onPressed: () => _onMenuSelected(context, 'more'),
              icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF94A3B8)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            )
          else
            IconButton(
              onPressed: () => _startDirectChat(context, userId),
              icon: Icon(Icons.message_outlined, size: 20, color: Colors.blue.shade400),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
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