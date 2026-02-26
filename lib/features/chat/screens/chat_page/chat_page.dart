import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../controllers/chat_controller.dart';
import 'widgets/chat_message_widget.dart';
import 'widgets/message_input_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.arguments to pass user name or ID from previous screen
    final String userName = Get.arguments?['userName'] ?? 'Chat';

    // Ensure controller is put only once (better to put it earlier, e.g., in binding)
    final ChatController controller = Get.put(ChatController());

    // Scroll controller to auto-scroll to bottom
    final ScrollController scrollController = ScrollController();

    // Scroll to bottom when messages change
    ever(controller.messages, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            0.0, // Because reverse: true → 0 is bottom
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.setting_2),
            onPressed: () {
              // Open chat settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return Center(
                  child: Text(
                    'Dites bonjour 👋',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                reverse: true,
                itemCount: controller.messages.length,
                // Optional: improve performance if messages have similar height
                // itemExtent: 80,
                itemBuilder: (context, index) {
                  // Since reverse: true, index 0 is the latest message
                  final message = controller.messages[index];

                  return ChatMessageWidget(
                    messageId: message.id,
                    message: message.text ?? '',
                    isUserMessage: message.isUserMessage,
                    timestamp: message.timestamp,
                    attachments: message.attachments,
                    type: message.type,
                  );
                },
              );
            }),
          ),

          // Message input at the bottom
          const MessageInputWidget(),
        ],
      ),
    );
  }
}