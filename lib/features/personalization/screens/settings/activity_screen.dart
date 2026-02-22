import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:decoright/utils/helpers/helper_functions.dart';
import 'package:decoright/common/widgets/appbar/appbar.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Activity'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? TColors.light : TColors.dark,
              ),
            ),
            const SizedBox(height: 24),
            
            Expanded(
              child: ListView(
                children: [
                  _buildActivityItem(
                    context: context,
                    icon: Iconsax.document,
                    title: 'Service Request Created',
                    subtitle: 'Interior Design for living room',
                    time: '2 hours ago',
                    status: 'Submitted',
                  ),
                  const SizedBox(height: 12),
                  _buildActivityItem(
                    context: context,
                    icon: Iconsax.message,
                    title: 'New Message Received',
                    subtitle: 'Designer replied to your request',
                    time: '1 day ago',
                    status: 'Unread',
                  ),
                  const SizedBox(height: 12),
                  _buildActivityItem(
                    context: context,
                    icon: Iconsax.tick_circle,
                    title: 'Request Completed',
                    subtitle: 'Fixed Design project finished',
                    time: '3 days ago',
                    status: 'Completed',
                  ),
                  const SizedBox(height: 12),
                  _buildActivityItem(
                    context: context,
                    icon: Iconsax.shopping_cart,
                    title: 'Order Placed',
                    subtitle: 'Furniture purchase confirmed',
                    time: '1 week ago',
                    status: 'Processing',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required String status,
  }) {
    final isDark = THelperFunctions.isDarkMode(context);
    Color statusColor = Colors.grey;
    
    switch (status.toLowerCase()) {
      case 'submitted':
        statusColor = Colors.blue;
        break;
      case 'unread':
        statusColor = Colors.orange;
        break;
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'processing':
        statusColor = Colors.purple;
        break;
    }
    
    return Card(
      color: isDark ? TColors.darkGrey : TColors.lightGrey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? TColors.darkerGrey : TColors.lightGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: statusColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? TColors.light : TColors.dark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isDark ? TColors.lightGrey : TColors.darkGrey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          color: isDark ? TColors.grey : TColors.grey,
                          fontSize: 11,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}