// widgets/messages_list.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../controllers/message_controller.dart';


class MessageList extends StatelessWidget {
  final List<ConversationItem> messages;
  final Function(ConversationItem) onItemTap;

  const MessageList({
    super.key,
    required this.messages,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final convo = messages[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: TColors.primary.withOpacity(0.2),
            child: Text(
              convo.userName[0],
              style: const TextStyle(color: TColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            convo.userName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            convo.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(convo.timestamp),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              if (convo.unreadCount > 0)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: TColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${convo.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          onTap: () => onItemTap(convo),
        );
      },
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date.isAfter(today)) {
      return DateFormat('HH:mm').format(date);
    } else if (date.isAfter(yesterday)) {
      return 'Hier';
    } else {
      return DateFormat('dd/MM').format(date);
    }
  }
}