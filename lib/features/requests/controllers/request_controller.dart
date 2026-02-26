import 'dart:io';

import 'package:decoright/core/config/supabase_config.dart';

import 'package:decoright/navigation_menu.dart'; // Import NavigationController

import 'package:decoright/data/services/chat_service.dart';
import 'package:decoright/data/services/request_service.dart';
import 'package:decoright/features/chat/controllers/message_controller.dart';
import 'package:decoright/features/personalization/controllers/profile_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestController extends GetxController {
  final RequestService _requestService = RequestService();
  final ChatService _chatService = ChatService(); // Instantiate ChatService

  final isLoading = false.obs;
  final requests = <Map<String, dynamic>>[].obs;
  
  // Dynamic Types from Supabase
  final serviceTypes = <Map<String, dynamic>>[].obs;
  final spaceTypes = <Map<String, dynamic>>[].obs;
  
  // Create Request Form State
  final selectedServiceTypeId = RxnString();
  final selectedSpaceTypeId = RxnString();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final areaController = TextEditingController();
  final durationController = TextEditingController();
  final selectedFiles = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTypes();
    loadRequests();
  }

  Future<void> fetchTypes() async {
    try {
      final sTypes = await SupabaseConfig.client.from('service_types').select('id, name');
      final spTypes = await SupabaseConfig.client.from('space_types').select('id, name');
      
      serviceTypes.value = List<Map<String, dynamic>>.from(sTypes);
      spaceTypes.value = List<Map<String, dynamic>>.from(spTypes);
    } catch (e) {
      print('Error fetching types: $e');
    }
  }

  /// Load service requests (all for admin, own for customer)
  Future<void> loadRequests() async {
    try {
      isLoading.value = true;
      
      final profileController = Get.put(ProfileController());
      // Ensure profile is loaded
      if (profileController.userProfile.value == null) {
        await profileController.loadUserProfile();
      }
      
      final isAdmin = profileController.role == 'admin';
      
      final data = isAdmin 
          ? await _requestService.getAllRequests()
          : await _requestService.getMyRequests();
          
      requests.value = data;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load requests: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// [ADMIN] Update request status
  Future<void> updateStatus(String requestId, String newStatus) async {
    try {
      isLoading.value = true;
      await _requestService.updateRequestStatus(
        requestId: requestId,
        status: newStatus,
      );
      
      Get.snackbar(
        'Success',
        'Status updated to $newStatus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
      
      await loadRequests();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update status: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a service request
  /// Cancel a service request (Soft Delete)
  Future<void> cancelRequest(dynamic requestId) async {
    try {
      isLoading.value = true;
      final idStr = requestId?.toString();
      if (idStr == null || idStr.isEmpty) {
        Get.snackbar('Error', 'Invalid request ID');
        return;
      }

      // Check current status if possible (optimistic check)
      final currentRequest = requests.firstWhereOrNull((r) => r['id'].toString() == idStr);
      if (currentRequest != null && currentRequest['status'] != 'Submitted') {
         Get.snackbar('Error', 'Cannot cancel request that is already processed.');
         return;
      }

      final cancelled = await _requestService.cancelServiceRequest(idStr);
      
      if (cancelled.isEmpty) {
        throw Exception('Could not cancel request. Permission denied or request not found.');
      }

      // Optimistic update - Change status to Cancelled instead of removing
      final index = requests.indexWhere((r) => r['id'].toString() == idStr);
      if (index != -1) {
        final updatedRequest = Map<String, dynamic>.from(requests[index]);
        updatedRequest['status'] = 'Cancelled';
        requests[index] = updatedRequest;
      }
      
      Get.snackbar(
        'Success',
        'Request cancelled successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
      
      // Still reload to be sure
      // await loadRequests(); // Optional if optimistic update works well, but safer to keep
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel request: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Pick files for attachment
  Future<void> pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null) {
        selectedFiles.addAll(result.paths.map((path) => File(path!)).toList());
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick files: $e');
    }
  }
  
  /// Remove a selected file
  void removeFile(File file) {
    selectedFiles.remove(file);
  }

  /// Create a new service request
  Future<void> createRequest() async {
    try {
      if (selectedServiceTypeId.value == null) {
        Get.snackbar('Error', 'Please select a service type');
        return;
      }
      
      final durationText = durationController.text.trim();
      int? duration;
      if (durationText.isNotEmpty) {
        duration = int.tryParse(durationText);
        if (duration == null || duration <= 0) {
          Get.snackbar('Error', 'Please enter a valid duration in days');
          return;
        }
      }
      
      isLoading.value = true;
      
      // 1. Create Request
      final request = await _requestService.createServiceRequest(
        // The serviceType argument in service might need changing or just pass ID
        // Wait, RequestService.createServiceRequest expects serviceType as String but uses it for lookup.
        // I'll update RequestService to accept IDs directly for better efficiency.
        serviceType: selectedServiceTypeId.value!, 
        description: descriptionController.text.trim(),
        location: locationController.text.trim().isNotEmpty ? locationController.text.trim() : "TBD",
        spaceType: selectedSpaceTypeId.value ?? '', 
        areaSqm: double.tryParse(areaController.text.trim()),
        duration: duration,
      );
      
      final requestId = request['id'] as String;
      
      // 2. Upload attachments (if any)
      if (selectedFiles.isNotEmpty) {
        await _chatService.sendMessage(
          requestId: requestId,
          content: 'Request Attachments', // Configurable message
          attachments: List<File>.from(selectedFiles),
        );
      }
      
      // Clear form
      selectedServiceTypeId.value = null;
      selectedSpaceTypeId.value = null;
      descriptionController.clear();
      durationController.clear();
      locationController.clear();
      areaController.clear();
      selectedFiles.clear();
      
      // Reload requests
      await loadRequests();
      
      if (Get.isRegistered<MessageController>()) {
        Get.find<MessageController>().loadConversations();
      }

      // Navigate to Requests Tab (Index 1) if possible
      try {
        if (Get.isRegistered<NavigationController>()) {
          Get.find<NavigationController>().selectedIndex.value = 1;
        }
      } catch (e) {
        // Ignore if navigation controller issues
      }

      // Close create screen
      Get.back();

      Get.snackbar(
        'Success',
        'Request created successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      ); 
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create request: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    descriptionController.dispose();
    durationController.dispose();
    locationController.dispose();
    areaController.dispose();
    super.onClose();
  }
}
