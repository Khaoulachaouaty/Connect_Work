import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/service_locator.dart';
import '../models/post_media.dart';
import 'package:connect_work/features/posts/data/models/comment_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cloudinary configuration : valeurs fournies.
  static const String _cloudinaryUploadUrl =
      'https://api.cloudinary.com/v1_1/db6pwhr/upload';
  static const String _cloudinaryPreset = 'connect_work_preset';
  static const String _cloudinaryFolder = 'posts';

  Stream<List<Post>> watchPosts({List<String>? joinedGroupIds}) {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Post.fromFirestore(doc.data(), doc.id))
              .where((post) => 
                post.groupId == null || 
                (joinedGroupIds != null && joinedGroupIds.contains(post.groupId))
              )
              .toList(),
        );
  }

  Stream<List<Post>> watchGroupPosts(String groupId) {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Post.fromFirestore(doc.data(), doc.id))
              .where((post) => post.groupId == groupId)
              .toList(),
        );
  }

  // --- CRUD POSTES ---

  Future<void> createPost(Post post) async {
    await _firestore.collection('posts').add(post.toFirestore());
  }

  Future<void> updatePost(String postId, String newContent) async {
    await _firestore.collection('posts').doc(postId).update({
      'content': newContent,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deletePost(String postId) async {
    // Supprimer aussi les commentaires (subcollection) idéalement, mais Firestore ne le fait pas auto.
    await _firestore.collection('posts').doc(postId).delete();
  }

  // --- LIKES ---

  Future<bool> toggleLike(String postId, String userId) async {
    final postRef = _firestore.collection('posts').doc(postId);
    final doc = await postRef.get();
    if (!doc.exists) return false;

    final likedBy = List<String>.from(doc.data()?['likedBy'] ?? []);
    if (likedBy.contains(userId)) {
      await postRef.update({
        'likedBy': FieldValue.arrayRemove([userId]),
      });
      return false; // Unliked
    } else {
      await postRef.update({
        'likedBy': FieldValue.arrayUnion([userId]),
      });
      return true; // Liked
    }
  }

  // --- COMMENTAIRES ---

  Stream<List<Comment>> watchComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Comment.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Future<void> addComment(String postId, Comment comment, {required String postAuthorId}) async {
    final batch = _firestore.batch();
    
    final commentRef = _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc();
        
    final postRef = _firestore.collection('posts').doc(postId);

    batch.set(commentRef, comment.toFirestore());
    batch.update(postRef, {'comments': FieldValue.increment(1)});
    
    await batch.commit();

    // Notification
    if (postAuthorId != comment.authorId) {
      await getIt<NotificationService>().sendNotification(NotificationModel(
        id: '',
        userId: postAuthorId,
        fromId: comment.authorId,
        fromName: comment.authorName,
        fromAvatar: comment.authorAvatar,
        postId: postId,
        type: NotificationType.comment,
        message: 'a commenté votre publication',
        createdAt: DateTime.now(),
      ));
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    final batch = _firestore.batch();
    final commentRef = _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId);
    final postRef = _firestore.collection('posts').doc(postId);

    batch.delete(commentRef);
    batch.update(postRef, {'comments': FieldValue.increment(-1)});

    await batch.commit();
  }

  Future<void> updateComment(String postId, String commentId, String newContent) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .update({
      'content': newContent,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String> uploadMedia(
    File file,
    PostMediaType mediaType,
    String authorId,
  ) async {
    final uri = Uri.parse(_cloudinaryUploadUrl);

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _cloudinaryPreset
      ..fields['folder'] = _cloudinaryFolder
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'Cloudinary upload failed (${response.statusCode}): $body',
      );
    }

    final jsonData = json.decode(body);
    if (jsonData['secure_url'] == null) {
      throw Exception('Impossible de récupérer secure_url : $jsonData');
    }

    return jsonData['secure_url'];
  }
}
