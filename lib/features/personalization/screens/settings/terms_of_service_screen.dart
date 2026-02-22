import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:decoright/utils/helpers/helper_functions.dart';
import 'package:decoright/common/widgets/appbar/appbar.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Terms of Service'),
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
                      _buildTermSection(
                        context: context,
                        title: 'Acceptance of Terms',
                        content: 'By accessing and using the Decoright app, you accept and agree to be bound by the terms and provision of this agreement.',
                      ),
                      const SizedBox(height: 16),
                      _buildTermSection(
                        context: context,
                        title: 'Use License',
                        content: 'Permission is granted to temporarily download one copy of the app per device for personal, non-commercial transitory viewing only.',
                      ),
                      const SizedBox(height: 16),
                      _buildTermSection(
                        context: context,
                        title: 'Disclaimer',
                        content: 'The materials within the app are provided on an "is" basis. Decoright makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties.',
                      ),
                      const SizedBox(height: 16),
                      _buildTermSection(
                        context: context,
                        title: 'Limitations',
                        content: 'In no event shall Decoright or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the app.',
                      ),
                      const SizedBox(height: 16),
                      _buildTermSection(
                        context: context,
                        title: 'Revisions and Errata',
                        content: 'The materials appearing in the app could include technical, typographical, or photographic errors. Decoright does not warrant that any of the materials are accurate, complete, or current.',
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

  Widget _buildTermSection({
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
              Iconsax.clipboard_text,
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