import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth_state.dart';
import '../../../data/models/comment_model.dart';
import '../../../data/services/post_service.dart';

class CommentItem extends StatefulWidget {
  final Comment comment;
  final String postId;
  const CommentItem({super.key, required this.comment, required this.postId});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _isEditing = false;
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.comment.content);
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours} h';
    return 'Il y a ${diff.inDays} j';
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final userId = authState is AuthAuthenticated ? authState.user.uid : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: widget.comment.authorAvatar.isNotEmpty
                ? NetworkImage(widget.comment.authorAvatar)
                : null,
            child: widget.comment.authorAvatar.isEmpty
                ? Text(widget.comment.authorName[0].toUpperCase())
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.comment.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (_isEditing)
                        TextField(
                          controller: _editController,
                          //autoFocus: true,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                          ),
                          onSubmitted: (value) async {
                            if (value.trim().isNotEmpty) {
                              await getIt<PostService>().updateComment(
                                widget.postId,
                                widget.comment.id,
                                value.trim(),
                              );
                            }
                            setState(() => _isEditing = false);
                          },
                        )
                      else
                        Text(
                          widget.comment.content,
                          style: const TextStyle(fontSize: 14),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Row(
                    children: [
                      Text(
                        _formatTimeAgo(widget.comment.createdAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      if (widget.comment.authorId == userId) ...[
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => setState(() => _isEditing = !_isEditing),
                          child: Text(
                            _isEditing ? 'Annuler' : 'Modifier',
                            style: TextStyle(
                              fontSize: 11,
                              color: _isEditing ? Colors.grey : Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            getIt<PostService>().deleteComment(widget.postId, widget.comment.id);
                          },
                          child: const Text(
                            'Supprimer',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
