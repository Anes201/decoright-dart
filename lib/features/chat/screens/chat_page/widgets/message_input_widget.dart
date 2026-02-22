// message_input_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/message_input_controller.dart';

class MessageInputWidget extends StatelessWidget {
  const MessageInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(MessageInputController()); // Or Get.find() if already put elsewhere

    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Attachment Previews
          if (controller.chatController.selectedAttachments.isNotEmpty)
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? TColors.dark.withOpacity(0.5) : TColors.light.withOpacity(0.5),
                border: Border(top: BorderSide(color: isDark ? TColors.darkerGrey : TColors.grey)),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: controller.chatController.selectedAttachments.length,
                itemBuilder: (context, index) {
                  final file = controller.chatController.selectedAttachments[index];
                  final isImage = ['.jpg', '.jpeg', '.png', '.gif'].any((ext) => file.path.toLowerCase().endsWith(ext));

                  return Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 8),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: isImage
                              ? Image.file(file, width: 70, height: 70, fit: BoxFit.cover)
                              : Container(
                                  color: isDark ? TColors.darkerGrey : TColors.grey,
                                  child: const Center(child: Icon(Icons.insert_drive_file, size: 30)),
                                ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () => controller.chatController.removeAttachment(index),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          // Upload Progress
          if (controller.chatController.isUploading.value)
            const LinearProgressIndicator(minHeight: 2),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? TColors.dark : TColors.light,
              border: Border(top: BorderSide(color: isDark ? TColors.darkerGrey : TColors.grey)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Attachment button
                  if (!controller.isRecording.value)
                  IconButton(
                    icon: Icon(
                      Iconsax.add,
                      color: isDark ? TColors.white : TColors.dark,
                    ),
                    onPressed: controller.showAttachmentOptions,
                  ),

                  // Text input or Recording UI
                  Expanded(
                    child: controller.isRecording.value 
                    ? Row(
                        children: [
                          const Icon(Icons.fiber_manual_record, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Obx(() {
                            final duration = controller.recordDuration.value;
                            final minutes = (duration ~/ 60).toString().padLeft(2, '0');
                            final seconds = (duration % 60).toString().padLeft(2, '0');
                            return Text('$minutes:$seconds', style: TextStyle(color: isDark ? TColors.white : TColors.dark));
                          }),
                          const Spacer(),
                          TextButton(
                            onPressed: controller.cancelRecording,
                            child: const Text('Annuler', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      )
                    : TextField(
                        controller: controller.textController,
                        focusNode: controller.focusNode,
                        minLines: 1,
                        maxLines: 5,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          hintText: 'Envoyer un message...',
                          hintStyle: TextStyle(
                            color: isDark ? TColors.grey : TColors.darkGrey,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onSubmitted: (_) => controller.sendTextMessage(),
                      ),
                  ),

                  // Send or Mic button
                  Obx(() {
                    if (controller.isRecording.value) {
                       return IconButton(
                        icon: const Icon(Iconsax.send_1, color: TColors.primary, size: 26),
                        onPressed: controller.stopRecording,
                      );
                    }
                    
                    final showSend = controller.hasText.value || controller.chatController.selectedAttachments.isNotEmpty;
                    
                    if (showSend) {
                       return IconButton(
                        icon: const Icon(Iconsax.send_1, color: TColors.primary, size: 26),
                        onPressed: controller.sendTextMessage,
                      );
                    } else {
                       return GestureDetector(
                        onLongPress: controller.startRecording,
                        onLongPressUp: controller.stopRecording, // Optional: stop on release
                        child: IconButton(
                          icon: Icon(Iconsax.microphone, color: isDark ? TColors.white : TColors.dark, size: 26),
                          onPressed: () {
                             // Tap to record logic (toggle) or hint
                             // For now let's just use tap to start/stop if user prefers tap over hold
                             // But typical UX is hold or tap-tap.
                             // Let's implement tap to start, tap to stop.
                             controller.startRecording();
                          }, 
                        ),
                       );
                    }
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}