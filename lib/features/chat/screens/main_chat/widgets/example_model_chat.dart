
/// Example model representing a message/chat item
class MessageItem {
  final String doctorName;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final String? avatarUrl;
  final bool isGroup;

  MessageItem( {
    required this.isGroup,
    required this.doctorName,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.avatarUrl,
  });
}
