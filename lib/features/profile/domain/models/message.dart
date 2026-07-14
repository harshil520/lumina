/// A message or conversation thread in the user's inbox.
class Message {
  const Message({
    required this.id,
    required this.senderName,
    required this.senderAvatar,
    required this.preview,
    required this.timestamp,
    required this.isRead,
    this.imageUrl,
  });

  final String id;
  final String senderName;
  final String senderAvatar;
  final String preview;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;
}
