import 'package:decoright/features/chat/screens/chat_page/chat_page.dart';
import 'package:decoright/features/requests/controllers/request_controller.dart';
import 'package:decoright/features/personalization/controllers/profile_controller.dart';
import 'package:decoright/features/requests/screens/create_request_screen.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:decoright/utils/helpers/helper_functions.dart';
import 'package:decoright/utils/loaders/shimmer_loader.dart';
import 'package:decoright/utils/constants/sizes.dart';
import 'package:decoright/l10n/app_localizations.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RequestController());
    final i18n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.myServiceRequests),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView.separated(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
            itemBuilder: (_, __) => const TShimmerEffect(width: double.infinity, height: 160),
          );
        }

        if (controller.requests.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.loadRequests,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.note, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        i18n.noRequestsYet,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(i18n.createFirstRequest),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadRequests,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
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
    final i18n = AppLocalizations.of(context)!;
    final isDark = THelperFunctions.isDarkMode(context);
    final status = request['status'] ?? 'Unknown';
    final locale = Get.locale?.languageCode ?? 'en';
    final serviceTypeData = request['service_types'];
    final serviceType = ((serviceTypeData is Map ? (serviceTypeData['display_name_$locale'] ?? serviceTypeData['display_name_en'] ?? serviceTypeData['name']) : request['service_type']) ?? i18n.serviceType)
        .toString()
        .replaceAll('_', ' ');
    final description = request['description'] ?? '';
    final requestId = request['id'];
    final updated_at = request['updated_at'];
    final created_at = request['created_at'];
    
    // Simple logic for "new/updated" indicator
    final bool isUpdated = updated_at != null && 
                          DateTime.parse(updated_at).difference(DateTime.parse(created_at)).inSeconds > 5;

    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkerGrey.withValues(alpha: 0.5) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? TColors.darkGrey : TColors.grey.withValues(alpha: 0.3)),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: InkWell(
        onTap: () => Get.to(
          () => const ChatScreen(),
          arguments: {'requestId': requestId, 'userName': serviceType},
        ),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(TSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: TColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Iconsax.note_1, color: TColors.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            serviceType,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(context, status),
                ],
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Iconsax.message, size: 16, color: TColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        i18n.openChat,
                        style: const TextStyle(
                          color: TColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (Get.find<ProfileController>().role == 'customer' && status == 'Submitted')
                        TextButton(
                          onPressed: () => _confirmCancel(context, i18n, requestId),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(i18n.cancel, style: const TextStyle(color: Colors.red, fontSize: 13)),
                        ),
                      if (Get.find<ProfileController>().role == 'admin')
                        _buildAdminMenu(requestId)
                      else
                        Icon(Iconsax.arrow_right_3, size: 16, color: isDark ? Colors.white54 : Colors.grey[400]),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _confirmCancel(BuildContext context, AppLocalizations i18n, String requestId) {
    Get.defaultDialog(
      title: i18n.confirmCancelTitle,
      middleText: i18n.confirmCancelMessage,
      onConfirm: () {
        Get.back();
        Get.find<RequestController>().cancelRequest(requestId);
      },
      onCancel: () => Get.back(),
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      textConfirm: i18n.ok,
      textCancel: i18n.cancel,
    );
  }

  Widget _buildAdminMenu(String requestId) {
    return PopupMenuButton<String>(
      icon: const Icon(Iconsax.edit, size: 18),
      onSelected: (newStatus) => Get.find<RequestController>().updateStatus(requestId, newStatus),
      itemBuilder: (context) => [
        'Submitted', 'Under Review', 'Waiting for Client Info', 
        'Approved', 'In Progress', 'Completed', 'Rejected'
      ].map((status) => PopupMenuItem(value: status, child: Text(status))).toList(),
    );
  }
}
