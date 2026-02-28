// message_input_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import 'package:decoright/l10n/app_localizations.dart';
import '../../../controllers/message_input_controller.dart';

class MessageInputWidget extends StatelessWidget {
  const MessageInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final i18n = AppLocalizations.of(context)!;
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? TColors.dark : TColors.light,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: isDark ? TColors.darkerGrey.withValues(alpha: 0.5) : TColors.grey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: controller.isRecording.value 
                            ? Row(
                                children: [
                                  const SizedBox(width: 8),
                                  const Icon(Icons.fiber_manual_record, color: Colors.red, size: 20),
                                  const SizedBox(width: 8),
                                  Obx(() {
                                    final duration = controller.recordDuration.value;
                                    final minutes = (duration ~/ 60).toString().padLeft(2, '0');
                                    final seconds = (duration % 60).toString().padLeft(2, '0');
                                    return Text('$minutes:$seconds', style: TextStyle(color: isDark ? TColors.white : TColors.dark, fontSize: 13));
                                  }),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: controller.cancelRecording,
                                    child: Text(i18n.cancelRecording, style: const TextStyle(color: Colors.red, fontSize: 13)),
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
                                  hintText: i18n.sendMessage,
                                  hintStyle: TextStyle(
                                    color: isDark ? TColors.grey : TColors.darkGrey,
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                ),
                                onSubmitted: (_) => controller.sendTextMessage(),
                              ),
                          ),
                          
                          // Mic icon inside when not typing and not recording
                          Obx(() {
                            final showSend = controller.hasText.value || 
                                            controller.chatController.selectedAttachments.isNotEmpty ||
                                            controller.isRecording.value;
                            
                            if (showSend) return const SizedBox.shrink();
                            
                            return GestureDetector(
                              onLongPress: controller.startRecording,
                              onLongPressUp: controller.stopRecording,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Iconsax.microphone, color: isDark ? TColors.white : TColors.dark, size: 20),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Send or Mic button
                  Obx(() {
                    final showSend = controller.hasText.value || 
                                    controller.chatController.selectedAttachments.isNotEmpty ||
                                    controller.isRecording.value;
                    
                    if (!showSend) return const SizedBox.shrink();
                    
                    return Container(
                      margin: const EdgeInsets.only(left: 8),
                      decoration: const BoxDecoration(
                        color: TColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Iconsax.send_1, color: Colors.white, size: 22),
                        onPressed: controller.isRecording.value ? controller.stopRecording : controller.sendTextMessage,
                      ),
                    );
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