import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import 'example_model_chat.dart';


/// Single message item widget
class MessageListItem extends StatelessWidget {
  final MessageItem item;
  final VoidCallback onTap;

  const MessageListItem({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: TColors.primary.withOpacity(0.1),
        backgroundImage:
        (item.avatarUrl != null) ? NetworkImage(item.avatarUrl!) : null,
        child: (item.avatarUrl == null)
            ? Text(
          item.doctorName.isNotEmpty
              ? item.doctorName.substring(0, 2)
              : '?',
          style: const TextStyle(
            color: TColors.primary,
            fontWeight: FontWeight.bold,
          ),
        )
            : null,
      ),
      title: Text(
        item.doctorName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        item.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.time,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
          if (item.unreadCount > 0)
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: TColors.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${item.unreadCount}',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }
}
