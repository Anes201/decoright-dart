import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:decoright/utils/helpers/helper_functions.dart';
import 'package:decoright/utils/constants/sizes.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:decoright/l10n/app_localizations.dart';
import 'package:decoright/features/requests/screens/create_request_screen.dart';
import '../../controllers/message_controller.dart';
import 'widgets/messages_list.dart';

class MessagesPage extends StatelessWidget {
  MessagesPage({Key? key}) : super(key: key);
  final MessageController controller = Get.put(MessageController());
  final RxBool isSearching = false.obs;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final i18n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? TColors.dark : TColors.light,
      appBar: AppBar(
        title: Obx(() => isSearching.value
            ? TextField(
                autofocus: true,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: i18n.search,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) => controller.searchQuery.value = value,
              )
            : Text(i18n.messages, style: Theme.of(context).textTheme.headlineSmall)),
        centerTitle: false,
        backgroundColor: isDark ? TColors.dark : TColors.light,
        elevation: 0,
        actions: [
          Obx(() => IconButton(
                onPressed: () {
                  if (isSearching.value) {
                    isSearching.value = false;
                    controller.searchQuery.value = '';
                  } else {
                    isSearching.value = true;
                  }
                },
                icon: Icon(
                  isSearching.value ? Icons.close : Iconsax.search_normal,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ))
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.filteredMessages.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.loadConversations,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.message_search, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        i18n.noConversationsFound,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        i18n.createRequestToStartChat,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadConversations,
          child: Column(
            children: [
              // Full-screen message list showing real requests
              Expanded(
                child: MessageList(
                messages: controller.filteredMessages,
                onItemTap: controller.onMessageTap,
              ),
            ),
          ],
        ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TColors.primary,
        // Navigate to new request screen when tapped
        onPressed: () => Get.to(() => const CreateRequestScreen()),
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
    );
  }
}