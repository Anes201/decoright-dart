import 'dart:io';
import 'package:flutter/material.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:decoright/utils/helpers/helper_functions.dart';
import 'package:decoright/core/config/supabase_config.dart';
import 'package:decoright/features/chat/models/messages_model.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:decoright/features/chat/controllers/chat_controller.dart';
import 'chat_audio_player.dart';

class ChatMessageWidget extends StatelessWidget {
  final String message;
  final bool isUserMessage;
  final DateTime? timestamp;
  final dynamic attachments;
  final MessageType type;
  final String? messageId;

  const ChatMessageWidget({
    super.key,
    required this.message,
    required this.isUserMessage,
    this.timestamp,
    this.attachments,
    this.type = MessageType.text,
    this.messageId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final isDark = THelperFunctions.isDarkMode(context);
    final bubbleColor = isUserMessage
        ? TColors.primary
        : (isDark ? TColors.darkerGrey : Colors.white);

    final textColor = isUserMessage
        ? Colors.white
        : (isDark ? Colors.white : Colors.black87);

    final alignment = isUserMessage ? Alignment.centerRight : Alignment.centerLeft;
    final List<dynamic> attachmentList = (attachments as List<dynamic>?) ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Align(
            alignment: alignment,
            child: GestureDetector(
              onLongPress: isUserMessage && message.trim() != '(Message deleted)'
                  ? () => _showDeleteDialog(context, controller)
                  : null,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isUserMessage ? 20 : 4),
                    bottomRight: Radius.circular(isUserMessage ? 4 : 20),
                  ),
                  boxShadow: [
                    if (!isUserMessage)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Attachments Grid/List
                    if (attachmentList.isNotEmpty && type != MessageType.audio) ...[
                      _buildAttachments(context, attachmentList, isUserMessage),
                      if (message.trim().isNotEmpty && message.trim() != 'Pièce jointe')
                        const SizedBox(height: 8),
                    ],

                    if (type == MessageType.audio && message.trim() != '(Message deleted)')
                      _buildAudioMessage(context, attachmentList, isUserMessage),

                    if (type != MessageType.audio && message.trim().isNotEmpty && message.trim() != 'Pièce jointe')
                      Text(
                        message.trim(),
                        style: TextStyle(
                          color: message.trim() == '(Message deleted)' ? (isUserMessage ? Colors.white70 : Colors.grey) : textColor,
                          fontSize: 15,
                          height: 1.3,
                          fontStyle: message.trim() == '(Message deleted)' ? FontStyle.italic : null,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (timestamp != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
              child: Text(
                _formatTimestamp(timestamp!),
                style: TextStyle(
                  color: Colors.grey.withOpacity(0.8),
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAttachments(BuildContext context, List<dynamic> attachments, bool fromUser) {
    final images = attachments.where((a) {
      final name = a['name'] as String? ?? '';
      return ['.jpg', '.jpeg', '.png', '.gif'].any((ext) => name.toLowerCase().endsWith(ext));
    }).toList();

    final files = attachments.where((a) {
      final name = a['name'] as String? ?? '';
      return !['.jpg', '.jpeg', '.png', '.gif'].any((ext) => name.toLowerCase().endsWith(ext));
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (images.isNotEmpty)
          _buildImageGrid(context, images),
        if (files.isNotEmpty)
          ...files.map((file) => _buildFileItem(context, file, fromUser)),
      ],
    );
  }

  Widget _buildImageGrid(BuildContext context, List<dynamic> images) {
    if (images.length == 1) {
      return _buildImageThumbnail(context, images[0], isLarge: true);
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: images.map((img) => _buildImageThumbnail(context, img)).toList(),
    );
  }

  Widget _buildImageThumbnail(BuildContext context, dynamic attachment, {bool isLarge = false}) {
    final path = attachment['path'] as String? ?? '';
    final isLocal = attachment['isLocal'] == true;
    
    if (isLocal) {
      return GestureDetector(
        onTap: () => _showFullScreenImage(context, attachment),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(path),
            fit: BoxFit.cover,
            width: isLarge ? double.infinity : 100,
            height: isLarge ? 200 : 100,
          ),
        ),
      );
    }

    return FutureBuilder<String>(
      future: SupabaseConfig.client.storage
          .from('request-attachments')
          .createSignedUrl(path, 3600),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            width: isLarge ? double.infinity : 100,
            height: isLarge ? 200 : 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        return GestureDetector(
          onTap: () => _showFullScreenImage(context, attachment, signedUrl: snapshot.data),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              snapshot.data!,
              fit: BoxFit.cover,
              width: isLarge ? double.infinity : 100,
              height: isLarge ? 200 : 100,
              errorBuilder: (context, error, stackTrace) => Container(
                width: isLarge ? double.infinity : 100,
                height: isLarge ? 200 : 100,
                color: Colors.grey[300],
                child: const Icon(Icons.error),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFileItem(BuildContext context, dynamic attachment, bool fromUser) {
    final name = attachment['name'] as String? ?? 'File';
    final textColor = fromUser ? Colors.white : Colors.black87;

    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: fromUser ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.document, size: 20, color: fromUser ? Colors.white : TColors.primary),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              name,
              style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, dynamic attachment, {String? signedUrl}) async {
    final path = attachment['path'] as String? ?? '';
    final isLocal = attachment['isLocal'] == true;
    
    String? imageUrl = signedUrl;
    if (!isLocal && imageUrl == null) {
       imageUrl = await SupabaseConfig.client.storage
          .from('request-attachments')
          .createSignedUrl(path, 3600);
    }

    Get.dialog(
      Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: isLocal 
                  ? Image.file(File(path)) 
                  : Image.network(imageUrl!),
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDay == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (messageDay == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  Widget _buildAudioMessage(BuildContext context, List<dynamic> attachments, bool fromUser) {
    if (attachments.isEmpty) return const Text('Audio unavailable');
    
    final attachment = attachments.first; // Assume first attachment is the audio
    final path = attachment['path'] as String? ?? '';
    final isLocal = attachment['isLocal'] == true;

    return ChatAudioPlayer(
      audioPath: path,
      isLocal: isLocal,
      isUserMessage: fromUser,
    );
  }

  void _showDeleteDialog(BuildContext context, ChatController controller) {
    if (messageId == null) return;
    
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Message?'),
        content: const Text('This will replace the message content with a deletion notice.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteMessage(messageId!);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}