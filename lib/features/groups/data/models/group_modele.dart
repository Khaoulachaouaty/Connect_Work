class Group {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int memberCount;
  final bool isMember;
  final bool isPrivate;
  final String adminId;
  final List<String> members;
  final List<String> pendingMembers;
  final DateTime? createdAt;

  Group({
    required this.id,
    required this.name,
    this.description = '',
    required this.imageUrl,
    required this.memberCount,
    this.isMember = false,
    this.isPrivate = false,
    required this.adminId,
    this.members = const [],
    this.pendingMembers = const [],
    this.createdAt,
  });
}