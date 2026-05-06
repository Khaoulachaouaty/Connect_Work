import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image, file }

class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String content;
  final DateTime createdAt;
  final MessageType type;
  final String? mediaUrl;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.content,
    required this.createdAt,
    this.type = MessageType.text,
    this.mediaUrl,
  });

  factory Message.fromFirestore(Map<String, dynamic> data, String id) {
    return Message(
      id: id,
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      senderAvatar: data['senderAvatar'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      type: MessageType.values.firstWhere(
        (e) => e.toString().split('.').last == data['type'],
        orElse: () => MessageType.text,
      ),
      mediaUrl: data['mediaUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
      'type': type.toString().split('.').last,
      'mediaUrl': mediaUrl,
    };
  }
}
