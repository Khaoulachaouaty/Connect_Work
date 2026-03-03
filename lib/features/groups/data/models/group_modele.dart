class Group {
  final String id;
  final String name;
  final String imageUrl;
  final int memberCount;
  final bool isMember;

  Group({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.memberCount,
    this.isMember = false,
  });
}