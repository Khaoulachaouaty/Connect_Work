import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String id;
  final String name; // Nom du groupe ou nom par défaut
  final String avatar;
  final bool isGroup;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageTime;
  final Map<String, int> unreadCounts;
  final String? groupId;
  final Map<String, String> userNames; // Pour les DMs: {uid: name}
  final Map<String, String> userAvatars; // Pour les DMs: {uid: avatar}

  ChatRoom({
    required this.id,
    required this.name,
    required this.avatar,
    this.isGroup = false,
    required this.participants,
    this.lastMessage = '',
    required this.lastMessageTime,
    this.unreadCounts = const {},
    this.groupId,
    this.userNames = const {},
    this.userAvatars = const {},
  });

  factory ChatRoom.fromFirestore(Map<String, dynamic> data, String id) {
    return ChatRoom(
      id: id,
      name: data['name'] ?? '',
      avatar: data['avatar'] ?? '',
      isGroup: data['isGroup'] ?? false,
      participants: List<String>.from(data['participants'] ?? []),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      unreadCounts: Map<String, int>.from(data['unreadCounts'] ?? {}),
      groupId: data['groupId'],
      userNames: Map<String, String>.from(data['userNames'] ?? {}),
      userAvatars: Map<String, String>.from(data['userAvatars'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'avatar': avatar,
      'isGroup': isGroup,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'unreadCounts': unreadCounts,
      'groupId': groupId,
      'userNames': userNames,
      'userAvatars': userAvatars,
    };
  }

  // Méthode utilitaire pour obtenir le nom à afficher
  String getDisplayName(String currentUserId) {
    if (isGroup) return name;
    // Pour un DM, on cherche le nom de l'autre participant
    final otherId = participants.firstWhere((id) => id != currentUserId, orElse: () => '');
    return userNames[otherId] ?? name;
  }

  // Méthode utilitaire pour obtenir l'avatar à afficher
  String getDisplayAvatar(String currentUserId) {
    if (isGroup) return avatar;
    final otherId = participants.firstWhere((id) => id != currentUserId, orElse: () => '');
    return userAvatars[otherId] ?? avatar;
  }
}
