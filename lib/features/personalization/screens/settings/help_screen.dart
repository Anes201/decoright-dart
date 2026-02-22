import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:decoright/utils/helpers/helper_functions.dart';
import 'package:decoright/common/widgets/appbar/appbar.dart';
import 'privacy_policy_screen.dart';
import 'support_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Help Center'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How can we help you?',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? TColors.light : TColors.dark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Browse our help topics below',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isDark ? TColors.lightGrey : TColors.darkGrey,
              ),
            ),
            const SizedBox(height: 24),
            
            Expanded(
              child: ListView(
                children: [
                  _buildHelpOption(
                    context: context,
                    icon: Iconsax.document,
                    title: 'Getting Started',
                    subtitle: 'Learn how to use the app',
                    onTap: () {
                      Get.snackbar(
                        'Info',
                        'Getting started guide would be displayed here',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.blue.withOpacity(0.1),
                        colorText: Colors.blue,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildHelpOption(
                    context: context,
                    icon: Iconsax.message_text,
                    title: 'Messaging',
                    subtitle: 'How to chat with designers',
                    onTap: () {
                      Get.snackbar(
                        'Info',
                        'Messaging guide would be displayed here',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.blue.withOpacity(0.1),
                        colorText: Colors.blue,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildHelpOption(
                    context: context,
                    icon: Iconsax.shopping_cart,
                    title: 'Orders',
                    subtitle: 'Track and manage your orders',
                    onTap: () {
                      Get.snackbar(
                        'Info',
                        'Order management guide would be displayed here',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.blue.withOpacity(0.1),
                        colorText: Colors.blue,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildHelpOption(
                    context: context,
                    icon: Iconsax.security_user,
                    title: 'Account Security',
                    subtitle: 'Manage your account settings',
                    onTap: () {
                      Get.snackbar(
                        'Info',
                        'Account security guide would be displayed here',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.blue.withOpacity(0.1),
                        colorText: Colors.blue,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildHelpOption(
                    context: context,
                    icon: Iconsax.card,
                    title: 'Payments',
                    subtitle: 'Payment methods and billing',
                    onTap: () {
                      Get.snackbar(
                        'Info',
                        'Payment guide would be displayed here',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.blue.withOpacity(0.1),
                        colorText: Colors.blue,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildHelpOption(
                    context: context,
                    icon: Iconsax.shield_security,
                    title: 'Privacy & Security',
                    subtitle: 'Your privacy and data protection',
                    onTap: () {
                      Get.to(() => const PrivacyPolicyScreen());
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Contact support button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const SupportScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  foregroundColor: TColors.light,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.message_edit),
                    const SizedBox(width: 8),
                    Text(
                      'Contact Support',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = THelperFunctions.isDarkMode(context);
    
    return Card(
      color: isDark ? TColors.darkGrey : TColors.lightGrey,
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isDark ? TColors.darkerGrey : TColors.lightGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isDark ? TColors.primary : TColors.primary,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? TColors.light : TColors.dark,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDark ? TColors.lightGrey : TColors.darkGrey,
          ),
        ),
        trailing: Icon(
          Iconsax.arrow_right_3,
          color: isDark ? TColors.lightGrey : TColors.darkGrey,
        ),
        onTap: onTap,
      ),
    );
  }
}