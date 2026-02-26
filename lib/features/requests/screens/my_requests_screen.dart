import 'package:decoright/features/chat/screens/chat_page/chat_page.dart';
import 'package:decoright/features/requests/controllers/request_controller.dart';
import 'package:decoright/features/personalization/controllers/profile_controller.dart';
import 'package:decoright/features/requests/screens/create_request_screen.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RequestController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Service Requests'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.requests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.note, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No requests yet',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Create your first service request!'),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadRequests,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.requests.length,
            itemBuilder: (context, index) {
              final request = controller.requests[index];
              return _RequestCard(request: request);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const CreateRequestScreen()),
        backgroundColor: TColors.primary,
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final Map<String, dynamic> request;

  const _RequestCard({required this.request});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Submitted':
        return Colors.blue;
      case 'Under Review':
        return Colors.orange;
      case 'Approved':
        return Colors.green;
      case 'In Progress':
        return Colors.purple;
      case 'Completed':
        return Colors.teal;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = request['status'] ?? 'Unknown';
    final serviceTypeData = request['service_types'];
    final serviceType = ((serviceTypeData is Map ? serviceTypeData['name'] : request['service_type']) ?? 'Service')
        .toString()
        .replaceAll('_', ' ');
    final description = request['description'] ?? '';
    final requestId = request['id'];
    final updated_at = request['updated_at'];
    final created_at = request['created_at'];
    
    // Simple logic for "new/updated" indicator: if updated_at is significantly after created_at
    final bool isUpdated = updated_at != null && 
                          DateTime.parse(updated_at).difference(DateTime.parse(created_at)).inSeconds > 5;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // Navigate to chat with this request
          Get.to(
            () => const ChatScreen(),
            arguments: {
              'requestId': requestId,
              'userName': serviceType,
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Iconsax.note_1,
                        color: TColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          serviceType,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: _getStatusColor(status),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Iconsax.message,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Open Chat',
                        style: TextStyle(
                          color: TColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      
                      // Cancel Button (Only for CUSTOMER and if not completed/rejected)
                      // Cancel Button (Only for CUSTOMER and if Submitted)
                      if (Get.find<ProfileController>().role == 'customer' && 
                          status == 'Submitted')
                        TextButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: 'Cancel Request',
                              middleText: 'Are you sure you want to cancel this request?',
                              onConfirm: () {
                                Get.back();
                                Get.find<RequestController>().cancelRequest(requestId);
                              },
                              onCancel: () => Get.back(),
                              confirmTextColor: Colors.white,
                              buttonColor: Colors.red,
                            );
                          },
                          child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                        ),

                      // Admin Status Update
                      Get.find<ProfileController>().role == 'admin' 
                        ? PopupMenuButton<String>(
                            icon: const Icon(Iconsax.edit, size: 20),
                            onSelected: (newStatus) {
                               Get.find<RequestController>().updateStatus(requestId, newStatus);
                            },
                            itemBuilder: (context) => [
                              'Submitted', 'Under Review', 'Waiting for Client Info', 
                              'Approved', 'In Progress', 'Completed', 'Rejected'
                            ].map((status) => PopupMenuItem(
                              value: status,
                              child: Text(status),
                            )).toList(),
                          )
                        : Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.grey[400],
                          ),
                    ],
                  ),
                ],
              ),
            ),
            if (isUpdated)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Iconsax.notification, size: 12, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
