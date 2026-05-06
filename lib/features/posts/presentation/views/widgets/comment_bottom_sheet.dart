import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth_state.dart';
import '../../../data/models/comment_model.dart';
import '../../../data/models/post_media.dart';
import '../../../data/services/post_service.dart';
import 'comment_item.dart';

class CommentBottomSheet extends StatefulWidget {
  final Post post;
  const CommentBottomSheet({super.key, required this.post});

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final PostService _postService = getIt<PostService>();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      final comment = Comment(
        id: '',
        authorId: user.uid,
        authorName: user.fullName,
        authorAvatar: user.photoUrl ?? '',
        content: content,
        createdAt: DateTime.now(),
      );

      await _postService.addComment(
        widget.post.id, 
        comment, 
        postAuthorId: widget.post.authorId,
      );
      _commentController.clear();
      // Le StreamBuilder se mettra à jour tout seul
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'Commentaires',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<List<Comment>>(
              stream: _postService.watchComments(widget.post.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final comments = snapshot.data ?? [];
                if (comments.isEmpty) {
                  return const Center(
                    child: Text('Aucun commentaire pour le moment'),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: comments.length,
                  itemBuilder: (context, index) => CommentItem(
                    comment: comments[index],
                    postId: widget.post.id,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              left: 16,
              right: 16,
              top: 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Ajouter un commentaire...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _submitComment,
                  icon: const Icon(Icons.send, color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
