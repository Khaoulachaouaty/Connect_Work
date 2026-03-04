class Conversation {
  final String id;
  final String name;
  final String avatar;
  final String role;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isGroup;
  final int? memberCount; // ← AJOUTER CECI

  Conversation({
    required this.id,
    required this.name,
    required this.avatar,
    required this.role,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isGroup = false,
    this.memberCount, // ← AJOUTER CECI
  });
}