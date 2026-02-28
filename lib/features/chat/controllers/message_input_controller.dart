import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../screens/chat_page/widgets/attachment_option_widget.dart';
import 'chat_controller.dart';


class MessageInputController extends GetxController {
  final textController = TextEditingController();
  final focusNode = FocusNode();

  // Use Get.find() instead of Get.put() to avoid multiple instances
  final chatController = Get.find<ChatController>();

  final hasText = false.obs;
  final isRecording = false.obs;
  final recordDuration = 0.obs;
  
  late AudioRecorder _audioRecorder;
  String? _recordedPath;

  final List<Map<String, dynamic>> attachmentOptions = [
    {'title': 'Caméra', 'icon': Icons.camera_alt},
    {'title': 'Galerie', 'icon': Icons.photo_library},
    {'title': 'Document', 'icon': Icons.insert_drive_file},
  ];

  @override
  void onInit() {
    super.onInit();
    _audioRecorder = AudioRecorder();
    textController.addListener(() {
      hasText.value = textController.text.trim().isNotEmpty;
    });
  }

  @override
  void onClose() {
    _audioRecorder.dispose();
    textController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void sendTextMessage() {
    final text = textController.text.trim();
    if (text.isNotEmpty || chatController.selectedAttachments.isNotEmpty) {
      chatController.sendMessage(text);
      textController.clear();
      focusNode.requestFocus(); // Keep keyboard open
    }
  }

  void showAttachmentOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: THelperFunctions.isDarkMode(Get.context!)
              ? TColors.dark
              : TColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            Text(
              'Partager du contenu',
              textAlign: TextAlign.center,
              style: Theme.of(Get.context!).textTheme.titleLarge,
            ),
            const SizedBox(height: 32),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: attachmentOptions.length,
              itemBuilder: (context, index) {
                final option = attachmentOptions[index];
                return AttachmentOptionWidget(
                  icon: option['icon'] as IconData,
                  label: option['title'] as String,
                  onTap: () => handleAttachmentSelection(option['title'] as String),
                );
              },
            ),
            SizedBox(height: TSizes.defaultSpace + MediaQuery.of(Get.context!).padding.bottom),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  void handleAttachmentSelection(String type) {
    Get.back(); // Close bottom sheet
    switch (type) {
      case 'Caméra':
        chatController.pickImageFromCamera();
        break;
      case 'Galerie':
        chatController.pickImageFromGallery();
        break;
      case 'Document':
        chatController.pickDocument();
        break;
      default:
        break;
    }
  }

  Future<void> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        final path = '${directory.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        await _audioRecorder.start(const RecordConfig(), path: path);
        _recordedPath = path;
        isRecording.value = true;
        
        // Start duration timer
        _startDurationTimer();
      } else {
        Get.snackbar('Permission refusée', 'Veuillez autoriser l\'accès au microphone');
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      isRecording.value = false;
      _stopDurationTimer();
      
      if (path != null) {
        _recordedPath = path;
        // Send immediately or attach? 
        // For voice messages, usually send immediately
        await chatController.sendVoiceMessage(File(path));
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  Future<void> cancelRecording() async {
    try {
      await _audioRecorder.stop();
      isRecording.value = false;
      _stopDurationTimer();
      _recordedPath = null;
    } catch (e) {
      debugPrint('Error cancelling recording: $e');
    }
  }

  void _startDurationTimer() {
    recordDuration.value = 0;
    // Simple way, or use a Timer
    Future.doWhile(() async {
      if (!isRecording.value) return false;
      await Future.delayed(const Duration(seconds: 1));
      if (isRecording.value) {
        recordDuration.value++;
        return true;
      }
      return false;
    });
  }

  void _stopDurationTimer() {
    recordDuration.value = 0;
  }
}