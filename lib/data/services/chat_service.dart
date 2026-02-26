import 'package:decoright/core/config/supabase_config.dart';
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

    Map<String, dynamic>? firstMessage;

    // 2. Send Text Message (if content exists)
    if (content != null && content.isNotEmpty) {
      firstMessage = await _client.from('messages').insert({
        'chat_room_id': chatRoomId,
        'request_id': requestId,
        'sender_id': user.id,
        'content': content,
        'message_type': 'TEXT',
        'is_read': false,
      }).select().single();
    }

    // 3. Send Attachments as separate messages
    if (attachments != null && attachments.isNotEmpty) {
      for (final file in attachments) {
         final fileName = '$requestId/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
         await _client.storage
              .from('request-attachments')
              .upload(fileName, file);

         final mediaUrl = _client.storage.from('request-attachments').getPublicUrl(fileName);

         final msg = await _client.from('messages').insert({
            'chat_room_id': chatRoomId,
            'request_id': requestId,
            'sender_id': user.id,
            'content': '',
            'message_type': isVoiceMessage ? 'AUDIO' : 'IMAGE',
            'media_url': mediaUrl,
            'duration_seconds': isVoiceMessage ? 0 : null,
            'is_read': false,
         }).select().single();

         if (firstMessage == null) {
           firstMessage = msg;
         }
      }
    }
    
    return firstMessage ?? {};
  }

  /// Get messages for a request
  Future<List<Map<String, dynamic>>> getMessages(String requestId) async {
    // Need to find chat_room_id first? Or join.
    // Supabase can query nested: chat_rooms!inner(request_id)
    final response = await _client
        .from('messages')
        .select('*, chat_rooms!inner(request_id), profiles(full_name)') // updated profile cols
        .eq('chat_rooms.request_id', requestId)
        .order('created_at', ascending: true); // created_at

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
