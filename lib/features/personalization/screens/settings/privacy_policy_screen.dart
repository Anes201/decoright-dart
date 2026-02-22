import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:decoright/utils/helpers/helper_functions.dart';
import 'package:decoright/common/widgets/appbar/appbar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: isDark ? TColors.darkGrey : TColors.lightGrey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPolicySection(
                        context: context,
                        title: 'Information We Collect',
                        content: 'We collect information you provide directly to us, such as when you create an account, submit service requests, or communicate with our designers. This may include your name, email address, and project details.',
                      ),
                      const SizedBox(height: 16),
                      _buildPolicySection(
                        context: context,
                        title: 'How We Use Your Information',
                        content: 'We use your information to provide and improve our services, process your service requests, communicate with you, and personalize your experience.',
                      ),
                      const SizedBox(height: 16),
                      _buildPolicySection(
                        context: context,
                        title: 'Data Protection',
                        content: 'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
                      ),
                      const SizedBox(height: 16),
                      _buildPolicySection(
                        context: context,
                        title: 'Your Rights',
                        content: 'You have the right to access, update, or delete your personal information at any time. You can manage your preferences in the settings section of the app.',
                      ),
                      const SizedBox(height: 16),
                      _buildPolicySection(
                        context: context,
                        title: 'Changes to This Policy',
                        content: 'We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Last Updated: December 2025',
                style: TextStyle(
                  color: isDark ? TColors.grey : TColors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicySection({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    final isDark = THelperFunctions.isDarkMode(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Iconsax.document,
              size: 16,
              color: isDark ? TColors.primary : TColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? TColors.light : TColors.dark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            color: isDark ? TColors.lightGrey : TColors.darkGrey,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}