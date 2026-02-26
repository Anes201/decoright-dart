// widgets/settings_tile.dart
import 'package:decoright/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const SettingsTile({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    
    return ListTile(
      leading: Icon(icon, color: TColors.primary),
      title: Text(
        title, 
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: isDark ? TColors.light : TColors.dark,
        ),
      ),
      subtitle: subtitle != null 
        ? Text(
            subtitle!,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isDark ? TColors.grey : TColors.darkGrey,
            ),
          ) 
        : null,
      trailing: Icon(
        Iconsax.back_square, 
        size: 16,
        color: isDark ? TColors.grey : TColors.darkGrey,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}