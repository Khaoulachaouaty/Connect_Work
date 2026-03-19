import 'package:cloud_firestore/cloud_firestore.dart';

enum PostMediaType { image, video, pdf, none }

class Post {
  final String id;
  final String authorId;
  final String authorName;
  final String authorRole;
  final String authorAvatar;
  final String content;
  final DateTime createdAt;
  final PostMediaType mediaType;
  final String? mediaUrl;
  final String? fileName;
  final int likes;
  final int comments;

  Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.authorAvatar,
    required this.content,
    required this.createdAt,
    this.mediaType = PostMediaType.none,
    this.mediaUrl,
    this.fileName,
    this.likes = 0,
    this.comments = 0,
  });

  factory Post.fromFirestore(Map<String, dynamic> data, String id) {
    final mediaTypeString = data['mediaType'] as String? ?? 'none';
    return Post(
      id: id,
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      authorRole: data['authorRole'] ?? '',
      authorAvatar: data['authorAvatar'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      mediaType: PostMediaType.values.firstWhere(
        (value) => value.toString().split('.').last == mediaTypeString,
        orElse: () => PostMediaType.none,
      ),
      mediaUrl: data['mediaUrl'] as String?,
      fileName: data['fileName'] as String?,
      likes: (data['likes'] as int?) ?? 0,
      comments: (data['comments'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'authorRole': authorRole,
      'authorAvatar': authorAvatar,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'mediaType': mediaType.toString().split('.').last,
      'mediaUrl': mediaUrl,
      'fileName': fileName,
      'likes': likes,
      'comments': comments,
    };
  }

}