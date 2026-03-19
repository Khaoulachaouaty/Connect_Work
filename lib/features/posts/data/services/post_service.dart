import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../models/post_media.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cloudinary configuration : valeurs fournies.
  static const String _cloudinaryUploadUrl =
      'https://api.cloudinary.com/v1_1/db6pmpwhr/upload';
  static const String _cloudinaryPreset = 'connect_work_preset';
  static const String _cloudinaryFolder = 'posts';

  Stream<List<Post>> watchPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Post.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<String> uploadMedia(
    File file,
    PostMediaType mediaType,
    String authorId,
  ) async {
    // Cloudinary upload (facile + gratuit en dev)
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

    final data = http.Response(body, response.statusCode);
    final jsonData = dataToJson(data.body);

    if (jsonData['secure_url'] == null) {
      throw Exception('Impossible de récupérer secure_url : $jsonData');
    }

    return jsonData['secure_url'];
  }

  Map<String, dynamic> dataToJson(String jsonString) =>
      json.decode(jsonString) as Map<String, dynamic>;

  Future<void> createPost(Post post) async {
    await _firestore.collection('posts').add(post.toFirestore());
  }

  Future<void> likePost(String postId) async {
    await _firestore.collection('posts').doc(postId).update({
      'likes': FieldValue.increment(1),
    });
  }

  Future<void> addComment(String postId) async {
    await _firestore.collection('posts').doc(postId).update({
      'comments': FieldValue.increment(1),
    });
  }
}
