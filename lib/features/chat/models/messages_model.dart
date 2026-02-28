// features/chat/models/message_model.dart
import 'package:get/get.dart';

enum MessageType { text, image, audio }

class MessageModel {
  final String? id;              // Message ID from database
  final String? text;            // For text messages
  final String? imageUrl;        // Local path or URL for images
  final MessageType type;
  final bool isUserMessage;
  final DateTime timestamp;
  final String? senderName;      // Name of the sender
  final List<dynamic>? attachments; // File attachments

  MessageModel({
    this.id,
    this.text,
    this.imageUrl,
    required this.type,
    required this.isUserMessage,
    required this.timestamp,
    this.senderName,
    this.attachments,
  });

  MessageModel copyWith({
    String? id,
    String? text,
    String? imageUrl,
    MessageType? type,
    bool? isUserMessage,
    DateTime? timestamp,
    String? senderName,
    List<dynamic>? attachments,
  }) {
    return MessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      isUserMessage: isUserMessage ?? this.isUserMessage,
      timestamp: timestamp ?? this.timestamp,
      senderName: senderName ?? this.senderName,
      attachments: attachments ?? this.attachments,
    );
  }

  // Helper factory for text messages
  factory MessageModel.text({
    required String text,
    required bool isUserMessage,
  }) {
    return MessageModel(
      text: text,
      type: MessageType.text,
      isUserMessage: isUserMessage,
      timestamp: DateTime.now(),
    );
  }

  // Helper factory for image messages
  factory MessageModel.image({
    required String imagePath,
    required bool isUserMessage,
  }) {
    return MessageModel(
      imageUrl: imagePath,
      type: MessageType.image,
      isUserMessage: isUserMessage,
      timestamp: DateTime.now(),
    );
  }
}