import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromFirestore(Map<String, dynamic> data, String id) {
    return Comment(
      id: id,
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      authorAvatar: data['authorAvatar'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
