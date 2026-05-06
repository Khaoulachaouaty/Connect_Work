import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType { like, comment, mention, system }

class NotificationModel {
  final String id;
  final String userId; // Destinataire
  final String fromId; // Auteur de l'action
  final String fromName;
  final String fromAvatar;
  final String? postId;
  final String? groupId;
  final NotificationType type;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.fromId,
    required this.fromName,
    required this.fromAvatar,
    this.postId,
    this.groupId,
    required this.type,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromFirestore(Map<String, dynamic> data, String id) {
    return NotificationModel(
      id: id,
      userId: data['userId'] ?? '',
      fromId: data['fromId'] ?? '',
      fromName: data['fromName'] ?? '',
      fromAvatar: data['fromAvatar'] ?? '',
      postId: data['postId'],
      groupId: data['groupId'],
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == data['type'],
        orElse: () => NotificationType.system,
      ),
      message: data['message'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'fromId': fromId,
      'fromName': fromName,
      'fromAvatar': fromAvatar,
      'postId': postId,
      'groupId': groupId,
      'type': type.toString().split('.').last,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
    };
  }
}

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendNotification(NotificationModel notification) async {
    // Éviter de s'envoyer une notification à soi-même
    if (notification.userId == notification.fromId) return;

    await _firestore.collection('notifications').add(notification.toFirestore());
  }

  Stream<List<NotificationModel>> watchNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Future<void> markAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'isRead': true,
    });
  }
  
  Future<void> deleteNotification(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).delete();
  }
}
