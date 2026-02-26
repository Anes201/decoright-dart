import 'package:decoright/core/config/supabase_config.dart';
import 'package:decoright/data/services/auth_service.dart';
import 'package:decoright/data/services/request_service.dart';
import 'package:get/get.dart';
import '../screens/chat_page/chat_page.dart'; // Adjust path

// Simple model for conversation preview (last message, unread count, etc.)
class ConversationItem {
  final String requestId;
  final String userName;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;
  final String? avatarUrl; // Optional for future

  ConversationItem({
    required this.requestId,
    required this.userName,
    required this.lastMessage,
    required this.timestamp,
    this.unreadCount = 0,
    this.avatarUrl,
  });
}

class MessageController extends GetxController {
  final RequestService _requestService = RequestService();
  final AuthService _authService = AuthService();

  // Observable list of conversations (for the MessagesPage list)
  var privateMessages = <ConversationItem>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadConversations();
  }

  Future<void> loadConversations() async {
    try {
      isLoading.value = true;
      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) return;

      final requests = await _requestService.getMyRequests();
      
      final List<ConversationItem> items = [];
      
      for (final req in requests) {
        final requestId = req['id'];
        
        // Fetch last message for this request
        final lastMsgResponse = await SupabaseConfig.client
            .from('messages')
            .select('content, created_at')
            .eq('request_id', requestId)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle();

        items.add(ConversationItem(
          requestId: requestId,
          userName: (req['service_types']?['name'] ?? req['service_type'] ?? 'Service Request')
              .toString()
              .replaceAll('_', ' '),
          lastMessage: lastMsgResponse?['content'] ?? req['description'] ?? 'No messages yet',
          timestamp: DateTime.parse(lastMsgResponse?['created_at'] ?? req['updated_at'] ?? req['created_at']),
          unreadCount: 0, 
        ));
      }

      // Sort by timestamp descending
      items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      privateMessages.assignAll(items);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load conversations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onMessageTap(ConversationItem conversation) {
    // Navigate to ChatScreen with user name and requestId
    Get.to(
          () => const ChatScreen(),
      arguments: {
        'userName': conversation.userName,
        'requestId': conversation.requestId,
      },
    );

    // Optional: mark as read
    final index = privateMessages.indexOf(conversation);
    if (index != -1 && privateMessages[index].unreadCount > 0) {
      privateMessages[index] = ConversationItem(
        requestId: conversation.requestId,
        userName: conversation.userName,
        lastMessage: conversation.lastMessage,
        timestamp: conversation.timestamp,
        unreadCount: 0,
        avatarUrl: conversation.avatarUrl,
      );
      privateMessages.refresh(); // Trigger UI update
    }
  }
}