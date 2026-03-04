import 'package:flutter/material.dart';
import '../../../data/model/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isGroup;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isMe) ...[
            _buildAvatar(),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (isGroup && !message.isMe && message.showSender)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      message.senderName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: message.isMe ? Colors.blue : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: message.isMe ? Colors.white : Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.time,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (message.isMe) return const SizedBox.shrink();
    
    return CircleAvatar(
      radius: 16,
      backgroundImage: NetworkImage(message.senderAvatar),
    );
  }
}