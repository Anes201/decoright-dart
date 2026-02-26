import 'dart:io';
import 'package:decoright/data/services/chat_service.dart';
import 'package:decoright/data/services/auth_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/messages_model.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();

  final messages = <MessageModel>[].obs;
  final isLoading = false.obs;
  final isUploading = false.obs; // Track upload state
  
  // Track selected but not yet sent attachments
  final selectedAttachments = <File>[].obs;
  
  late String requestId;
  RealtimeChannel? _subscription;

  @override
  void onInit() {
    super.onInit();
    // Get requestId from arguments
    requestId = Get.arguments?['requestId'] ?? '';
    
    if (requestId.isEmpty) {
      // Log error but don't show snackbar for example conversations
      debugPrint('ChatController: No requestId provided in arguments.');
      return;
    }
    
    loadMessages();
    subscribeToRealtime();
  }

  /// Load existing messages for this request
  Future<void> loadMessages() async {
    try {
      isLoading.value = true;
      final data = await _chatService.getMessages(requestId);
      final currentUserId = _authService.getCurrentUser()?.id ?? '';

      messages.value = data.map((msg) {
        return MessageModel(
          id: msg['id'],
          text: msg['content'],
          type: _determineMessageType(msg),
          isUserMessage: msg['sender_id'] == currentUserId,
          timestamp: DateTime.parse(msg['created_at']),
          senderName: msg['profiles']?['full_name'] ?? 'Unknown',
          attachments: msg['attachments'] ?? [],
        );
      }).toList().reversed.toList(); // Reverse to show latest at bottom if list is reversed in UI
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load messages: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  MessageType _determineMessageType(Map<String, dynamic> msg) {
    if (msg['content'] == 'Voice Message') return MessageType.audio;
    final attachments = msg['attachments'] as List<dynamic>?;
    if (attachments != null && attachments.isNotEmpty) {
      // Check if any attachment is flagged as audio
      if (attachments.any((a) => a['type'] == 'audio')) {
        return MessageType.audio;
      }
    }
    return MessageType.text;
  }

  /// Subscribe to realtime message updates
  void subscribeToRealtime() {
    final currentUserId = _authService.getCurrentUser()?.id ?? '';
    
    _subscription = _chatService.subscribeToMessages(
      requestId,
      (payload) {
        final data = payload['new'];
        final eventType = payload['event_type'];

        if (eventType == 'INSERT') {
          final message = MessageModel(
            id: data['id'],
            text: data['content'],
            type: _determineMessageType(data),
            isUserMessage: data['sender_id'] == currentUserId,
            timestamp: DateTime.parse(data['created_at']),
            senderName: 'Other User',
            attachments: data['attachments'] ?? [],
          );
          if (!messages.any((m) => m.id == message.id)) {
            messages.insert(0, message);
          }
        } else if (eventType == 'UPDATE') {
          final index = messages.indexWhere((m) => m.id == data['id']);
          if (index != -1) {
            messages[index] = MessageModel(
              id: data['id'],
              text: data['content'],
              type: _determineMessageType(data),
              isUserMessage: data['sender_id'] == currentUserId,
              timestamp: DateTime.parse(data['created_at']),
              senderName: messages[index].senderName,
              attachments: data['attachments'] ?? [],
            );
          }
        }
      },
    );
  }

  /// Send a voice message
  Future<void> sendVoiceMessage(File audioFile) async {
    // Validate requestId
    if (requestId.isEmpty) {
      Get.snackbar(
        'Error',
        'Cannot send message: No request ID.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    try {
      isUploading.value = true;
      
      // Create a temporary message for immediate feedback
      final currentUserId = _authService.getCurrentUser()?.id ?? '';
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      final tempMessage = MessageModel(
        id: tempId,
        text: 'Voice Message',
        type: MessageType.audio, // Ensure MessageType has audio
        isUserMessage: true,
        timestamp: DateTime.now(),
        senderName: 'You',
        attachments: [{'path': audioFile.path, 'name': 'voice_message.m4a', 'isLocal': true, 'type': 'audio'}],
      );
      
      messages.insert(0, tempMessage);

      final response = await _chatService.sendMessage(
        requestId: requestId,
        content: 'Voice Message',
        attachments: [audioFile],
        isVoiceMessage: true, 
      );
      
      // Update the temporary message with real ID and data
      final index = messages.indexWhere((m) => m.id == tempId);
      if (index != -1) {
        messages[index] = MessageModel(
          id: response['id'],
          text: response['content'],
          type: MessageType.audio,
          isUserMessage: true,
          timestamp: DateTime.parse(response['created_at']),
          senderName: 'You',
          attachments: response['attachments'] ?? [],
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send voice message: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isUploading.value = false;
    }
  }

  /// Send a text message with any selected attachments
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty && selectedAttachments.isEmpty) return;

    // Validate requestId
    if (requestId.isEmpty) {
      Get.snackbar(
        'Error',
        'Cannot send message: No request ID. Please create a service request first.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    try {
      if (selectedAttachments.isNotEmpty) {
        isUploading.value = true;
      }
      
      final attachmentsToSend = List<File>.from(selectedAttachments);
      
      // Create a temporary message for immediate feedback
      final currentUserId = _authService.getCurrentUser()?.id ?? '';
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      final tempMessage = MessageModel(
        id: tempId,
        text: text.trim().isEmpty ? 'Pièce jointe' : text.trim(),
        type: MessageType.text,
        isUserMessage: true,
        timestamp: DateTime.now(),
        senderName: 'You',
        attachments: attachmentsToSend.map((f) => {'path': f.path, 'name': f.path.split('/').last, 'isLocal': true}).toList(),
      );
      
      messages.insert(0, tempMessage);
      selectedAttachments.clear(); // Clear immediately to update UI

      final response = await _chatService.sendMessage(
        requestId: requestId,
        content: text.trim().isEmpty ? 'Pièce jointe' : text.trim(),
        attachments: attachmentsToSend,
      );
      
      // Update the temporary message with real ID and data
      final index = messages.indexWhere((m) => m.id == tempId);
      if (index != -1) {
        messages[index] = MessageModel(
          id: response['id'],
          text: response['content'],
          type: MessageType.text,
          isUserMessage: true,
          timestamp: DateTime.parse(response['created_at']),
          senderName: 'You',
          attachments: response['attachments'] ?? [],
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send message: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isUploading.value = false;
    }
  }

  /// Pick and send image from camera
  Future<void> pickImageFromCamera() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      selectedAttachments.add(File(photo.path));
    }
  }

  /// Pick and send image from gallery
  Future<void> pickImageFromGallery() async {
    final List<XFile> images = await _picker.pickMultiImage(
      imageQuality: 80,
    );

    if (images.isNotEmpty) {
      selectedAttachments.addAll(images.map((image) => File(image.path)));
    }
  }

  /// Pick and send document
  Future<void> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );

    if (result != null) {
      selectedAttachments.addAll(result.paths.whereType<String>().map((path) => File(path)));
    }
  }

  /// Remove a selected attachment
  void removeAttachment(int index) {
    if (index >= 0 && index < selectedAttachments.length) {
      selectedAttachments.removeAt(index);
    }
  }

  /// Delete a message
  Future<void> deleteMessage(String messageId) async {
    try {
      await _chatService.deleteMessage(messageId);
      // Local update will naturally happen via realtime or manual refresh
      // but let's update locally for instant feedback if desired
      final index = messages.indexWhere((m) => m.id == messageId);
      if (index != -1) {
        final old = messages[index];
        messages[index] = MessageModel(
          id: old.id,
          text: '(Message deleted)',
          type: MessageType.text,
          isUserMessage: old.isUserMessage,
          timestamp: old.timestamp,
          senderName: old.senderName,
          attachments: [],
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete message: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  @override
  void onClose() {
    _subscription?.unsubscribe();
    super.onClose();
  }
}