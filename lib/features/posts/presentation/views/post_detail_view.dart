import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../core/services/service_locator.dart';
import '../../data/models/comment_model.dart';
import '../../data/models/post_media.dart';
import '../../data/services/post_service.dart';
import 'widgets/post_card.dart';
import 'widgets/comment_item.dart';
import 'widgets/comment_bottom_sheet.dart';

class PostDetailView extends StatelessWidget {
  final String postId;
  final Post? initialPost;

  const PostDetailView({super.key, required this.postId, this.initialPost});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publication', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const BackButton(color: Colors.black),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').doc(postId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && initialPost == null) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Cette publication n\'existe plus.'));
          }

          final postData = snapshot.data!.data() as Map<String, dynamic>;
          final post = Post.fromFirestore(postData, snapshot.data!.id);

          return SingleChildScrollView(
            child: Column(
              children: [
                PostCard(post: post),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Commentaires',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                StreamBuilder<List<Comment>>(
                  stream: getIt<PostService>().watchComments(postId),
                  builder: (context, commentSnapshot) {
                    if (commentSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final comments = commentSnapshot.data ?? [];
                    if (comments.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('Soyez le premier à commenter !', style: TextStyle(color: Colors.grey)),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) => CommentItem(
                        comment: comments[index],
                        postId: postId,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 100), // Espace pour le champ de texte
              ],
            ),
          );
        },
      ),
      bottomSheet: initialPost != null ? _buildCommentInput(context, initialPost!) : null,
    );
  }

  Widget _buildCommentInput(BuildContext context, Post post) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => CommentBottomSheet(post: post),
          );
        },
        icon: const Icon(Icons.comment),
        label: const Text('Ajouter un commentaire'),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
