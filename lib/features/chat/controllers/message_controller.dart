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
      
      privateMessages.assignAll(requests.map((req) {
        return ConversationItem(
          requestId: req['id'],
          userName: req['service_type'] ?? 'Service Request',
          lastMessage: req['description'] ?? 'No description provided',
          timestamp: DateTime.parse(req['updated_at'] ?? req['created_at']),
          unreadCount: 0, // Placeholder for now
        );
      }).toList());
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