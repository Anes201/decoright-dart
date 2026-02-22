import 'package:decoright/core/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class ChatService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Send a message (with optional attachments)
  /// Send a message (with optional attachments)
  /// If attachments are provided, they are sent as separate messages of type IMAGE (or AUDIO).
  Future<void> sendMessage({
    required String requestId,
    required String? content, // Can be null if only sending file
    List<File>? attachments,
    bool isVoiceMessage = false,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    // 1. Get or Create Chat Room (if needed, but ERD says 1:1 request:room)
    // Assuming room exists or we query by request_id. ERD says MESSAGE links to chat_room_id.
    // We need to find the chat_room_id for this request_id.
    final roomResponse = await _client
        .from('chat_rooms')
        .select('id')
        .eq('request_id', requestId)
        .maybeSingle();
    
    String chatRoomId;
    if (roomResponse == null) {
        // Create room if not exists
        final newRoom = await _client
            .from('chat_rooms')
            .insert({'request_id': requestId, 'is_active': true})
            .select()
            .single();
        chatRoomId = newRoom['id'];
    } else {
        chatRoomId = roomResponse['id'];
    }

    // 2. Send Text Message (if content exists)
    if (content != null && content.isNotEmpty) {
      await _client.from('messages').insert({
        'chat_room_id': chatRoomId,
        'sender_id': user.id,
        'content': content,
        'message_type': 'TEXT',
        'is_read': false,
        'sent_at': DateTime.now().toIso8601String(),
      });
    }

    // 3. Send Attachments as separate messages
    if (attachments != null && attachments.isNotEmpty) {
      for (final file in attachments) {
         final fileName = '$requestId/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
         final storagePath = await _client.storage
              .from('request-attachments')
              .upload(fileName, file);

         // Helper to get public URL? or just store path. ERD says 'media_url'.
         // Usually we store the path or signed url unique key. 
         // But let's assume getPublicUrl for simplicity or just the path if client handles it.
         // 'media_url' suggests a full string.
         final mediaUrl = _client.storage.from('request-attachments').getPublicUrl(fileName);

         await _client.from('messages').insert({
            'chat_room_id': chatRoomId,
            'sender_id': user.id,
            'content': '',
            'message_type': isVoiceMessage ? 'AUDIO' : 'IMAGE', // Naive check, assuming all attachments same type
            'media_url': mediaUrl,
            'duration_seconds': isVoiceMessage ? 0 : null, // Todo: get duration
            'is_read': false,
            'sent_at': DateTime.now().toIso8601String(),
         });
      }
    }
  }

  /// Get messages for a request
  Future<List<Map<String, dynamic>>> getMessages(String requestId) async {
    // Need to find chat_room_id first? Or join.
    // Supabase can query nested: chat_rooms!inner(request_id)
    final response = await _client
        .from('messages')
        .select('*, chat_rooms!inner(request_id), profiles(first_name, last_name)') // updated profile cols
        .eq('chat_rooms.request_id', requestId)
        .order('sent_at', ascending: true); // created_at -> sent_at

    return List<Map<String, dynamic>>.from(response);
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
}
