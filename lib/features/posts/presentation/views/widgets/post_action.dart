import 'package:connect_work/core/services/notification_service.dart';
import 'package:connect_work/core/services/service_locator.dart';
import 'package:connect_work/features/posts/data/models/post_media.dart';
import 'package:connect_work/features/posts/data/services/post_service.dart';
import 'package:connect_work/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:connect_work/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'comment_bottom_sheet.dart';

class PostActions extends StatelessWidget {
  const PostActions({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final userId = authState is AuthAuthenticated ? authState.user.uid : '';
    final isLiked = post.likedBy.contains(userId);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _ActionButton(
            icon: isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
            iconColor: isLiked ? const Color(0xFFEF4444) : const Color(0xFF64748B),
            count: post.likesCount.toString(),
            onTap: () async {
              if (userId.isNotEmpty) {
                final liked = await getIt<PostService>().toggleLike(post.id, userId);
                if (liked && post.authorId != userId) {
                  await getIt<NotificationService>().sendNotification(NotificationModel(
                    id: '',
                    userId: post.authorId,
                    fromId: userId,
                    fromName: (authState as AuthAuthenticated).user.fullName,
                    fromAvatar: authState.user.photoUrl ?? '',
                    postId: post.id,
                    type: NotificationType.like,
                    message: 'a aimé votre publication',
                    createdAt: DateTime.now(),
                  ));
                }
              }
            },
          ),
          const SizedBox(width: 24),
          _ActionButton(
            icon: Icons.chat_bubble_outline_rounded,
            iconColor: const Color(0xFF64748B),
            count: post.comments.toString(),
            onTap: () {
              _showComments(context);
            },
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined, size: 20, color: Color(0xFF64748B)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentBottomSheet(post: post),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.count,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String count;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(icon, size: 22, color: iconColor ?? Colors.grey.shade600),
          const SizedBox(width: 6),
          Text(
            count,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}