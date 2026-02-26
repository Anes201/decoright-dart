import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:decoright/utils/helpers/helper_functions.dart';
import 'package:decoright/common/widgets/appbar/appbar.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Support'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need Help?',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? TColors.light : TColors.dark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Contact us for assistance',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isDark ? TColors.lightGrey : TColors.darkGrey,
              ),
            ),
            const SizedBox(height: 24),
            
            // Support options
            Card(
              color: isDark ? TColors.darkGrey : TColors.lightGrey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSupportOption(
                      context: context,
                      icon: Iconsax.message_text,
                      title: 'Live Chat',
                      subtitle: 'Chat with our support team',
                      onTap: () {
                        // In a real app, this would open a chat screen
                        Get.snackbar(
                          'Coming Soon',
                          'Live chat support coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue.withValues(alpha: 0.1),
                          colorText: Colors.blue,
                        );
                      },
                    ),
                    const Divider(height: 32),
                    _buildSupportOption(
                      context: context,
                      icon: Iconsax.call,
                      title: 'Call Us',
                      subtitle: '+213 123 456 789',
                      onTap: () async {
                        final Uri phoneUri = Uri.parse('tel:+213123456789');
                        if (await canLaunchUrl(phoneUri)) {
                          await launchUrl(phoneUri);
                        } else {
                          Get.snackbar(
                            'Error',
                            'Could not launch phone app',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red.withValues(alpha: 0.1),
                            colorText: Colors.red,
                          );
                        }
                      },
                    ),
                    const Divider(height: 32),
                    _buildSupportOption(
                      context: context,
                      icon: Iconsax.direct_right,
                      title: 'Email',
                      subtitle: 'support@decoright.dz',
                      onTap: () async {
                        final Uri emailUri = Uri.parse('mailto:support@decoright.dz?subject=Support Request');
                        if (await canLaunchUrl(emailUri)) {
                          await launchUrl(emailUri);
                        } else {
                          Get.snackbar(
                            'Error',
                            'Could not launch email app',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red.withValues(alpha: 0.1),
                            colorText: Colors.red,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            Text(
              'Frequently Asked Questions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? TColors.light : TColors.dark,
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              color: isDark ? TColors.darkGrey : TColors.lightGrey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildFAQItem(
                      context: context,
                      question: 'How do I submit a service request?',
                      answer: 'Tap the "+" button on the home screen to create a new service request.',
                    ),
                    const Divider(height: 24),
                    _buildFAQItem(
                      context: context,
                      question: 'Can I track my request status?',
                      answer: 'Yes, you can view all your requests and their status in the Requests tab.',
                    ),
                    const Divider(height: 24),
                    _buildFAQItem(
                      context: context,
                      question: 'How do I contact the designer?',
                      answer: 'You can chat with the designer directly through the chat feature in each request.',
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

  Widget _buildSupportOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = THelperFunctions.isDarkMode(context);
    
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDark ? TColors.darkerGrey : TColors.lightGrey,
          borderRadius: BorderRadius.circular(10),
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
        Iconsax.arrow_right_1,
        color: isDark ? TColors.lightGrey : TColors.darkGrey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildFAQItem({
    required BuildContext context,
    required String question,
    required String answer,
  }) {
    final isDark = THelperFunctions.isDarkMode(context);
    
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDark ? TColors.light : TColors.dark,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Text(
            answer,
            style: TextStyle(
              color: isDark ? TColors.lightGrey : TColors.darkGrey,
            ),
          ),
        ),
      ],
    );
  }
}