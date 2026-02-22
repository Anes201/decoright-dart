import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../controllers/message_controller.dart';
import 'widgets/messages_list.dart';

class MessagesPage extends StatelessWidget {
  MessagesPage({Key? key}) : super(key: key);
  final MessageController controller = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.search_normal),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.privateMessages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.message_search, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No conversations found',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create a service request to start a chat.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Full-screen message list showing real requests
            Expanded(
              child: MessageList(
                messages: controller.privateMessages,
                onItemTap: controller.onMessageTap,
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TColors.primary,
        // Navigate to new chat screen when tapped
        onPressed: () {
          // Get.to(() => ChatScreen()); // Example navigation
        },
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}