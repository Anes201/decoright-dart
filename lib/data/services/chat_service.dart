import 'package:decoright/core/config/supabase_config.dart';
import 'package:decoright/utils/helpers/network_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class ChatService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Send a message (with optional attachments)
  /// Send a message (with optional attachments)
  /// If attachments are provided, they are sent as separate messages of type IMAGE (or AUDIO).
  Future<Map<String, dynamic>> sendMessage({
    required String requestId,
    required String? content, // Can be null if only sending file
    List<File>? attachments,
    bool isVoiceMessage = false,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    // 1. Get or Create Chat Room
    final roomResponse = await _client
        .from('chat_rooms')
        .select('id')
        .eq('request_id', requestId)
        .maybeSingle();
    
    String chatRoomId;
    if (roomResponse == null) {
        final newRoom = await _client
            .from('chat_rooms')
            .insert({'request_id': requestId, 'is_active': true})
            .select()
            .single();
        chatRoomId = newRoom['id'];
    } else {
        chatRoomId = roomResponse['id'];
    }

    // 2. Upload Attachments First
    List<Map<String, dynamic>> uploadedAttachments = [];
    String? mediaUrl;

    if (attachments != null && attachments.isNotEmpty) {
      for (final file in attachments) {
         final fileName = '$requestId/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
         await _client.storage
              .from('request-attachments')
              .upload(fileName, file);

         final url = _client.storage.from('request-attachments').getPublicUrl(fileName);
         if (mediaUrl == null) mediaUrl = url; // Set primary media_url

         uploadedAttachments.add({
           'url': url,
           'name': file.path.split('/').last,
           'type': isVoiceMessage ? 'audio' : 'image',
         });
      }
    }

    // 3. Send Single Message Record (Text + Attached Media)
    // Don't send if completely empty
    if ((content == null || content.trim().isEmpty) && uploadedAttachments.isEmpty) {
      return {};
    }

    final messageType = isVoiceMessage ? 'AUDIO' : (uploadedAttachments.isNotEmpty ? 'IMAGE' : 'TEXT');

    final message = await _client.from('messages').insert({
      'chat_room_id': chatRoomId,
      'request_id': requestId,
      'sender_id': user.id,
      'content': content ?? '',
      'message_type': messageType,
      'media_url': mediaUrl, // Keep primary URL for backward compatibility if needed
      'attachments': uploadedAttachments.isNotEmpty ? uploadedAttachments : null,
      'duration_seconds': isVoiceMessage ? 0 : null,
      'is_read': false,
    }).select().single();

    return message;
  }

  Future<List<Map<String, dynamic>>> getMessages(String requestId) async {
    try {
      // Check Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return [];

      final response = await _client
          .from('messages')
          .select('*, chat_rooms!inner(request_id), profiles(full_name)')
          .eq('chat_rooms.request_id', requestId)
          .order('created_at', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }

  /// Subscribe to new messages (realtime)
  RealtimeChannel subscribeToMessages(
    String requestId,
    void Function(Map<String, dynamic>) onMessageReceived,
  ) {
    final channel = _client
        .channel('request_chat:$requestId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'request_id',
            value: requestId,
          ),
          callback: (payload) {
            onMessageReceived(payload.newRecord);
          },
        )
        .subscribe();

    return channel;
  }

  /// Delete a message (Soft delete by replacing content)
  Future<void> deleteMessage(String messageId) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _client.from('messages').delete().eq('id', messageId).eq('sender_id', user.id);
  }
}
