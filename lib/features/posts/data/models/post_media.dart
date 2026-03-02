enum PostMediaType { image, video, pdf, none }

class Post {
  final String id;
  final String authorName;
  final String authorRole;
  final String authorAvatar;
  final String content;
  final String timeAgo;
  final PostMediaType mediaType;
  final String? mediaUrl;
  final String? fileName;
  final int likes;
  final int comments;

  Post({
    required this.id,
    required this.authorName,
    required this.authorRole,
    required this.authorAvatar,
    required this.content,
    required this.timeAgo,
    this.mediaType = PostMediaType.none,
    this.mediaUrl,
    this.fileName,
    this.likes = 0,
    this.comments = 0,
  });
}