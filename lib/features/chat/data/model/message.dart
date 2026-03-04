class Message {
  final String id;
  final String senderName;
  final String senderAvatar;
  final String content;
  final String time;
  final bool isMe;
  final bool showSender;

  Message({
    required this.id,
    required this.senderName,
    required this.senderAvatar,
    required this.content,
    required this.time,
    required this.isMe,
    this.showSender = true,
  });
}