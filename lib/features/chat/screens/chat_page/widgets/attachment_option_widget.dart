// attachment_option_widget.dart
import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class AttachmentOptionWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const AttachmentOptionWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    // Dynamic color based on label/type could be passed, but for now let's use a nice surface color
    final bgColor = isDark ? TColors.darkerGrey : TColors.lightContainer;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? TColors.borderPrimary : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
             if (!isDark) 
               BoxShadow(
                 color: Colors.grey.withOpacity(0.1),
                 blurRadius: 10,
                 offset: const Offset(0, 4),
               ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? TColors.black : TColors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: TColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}