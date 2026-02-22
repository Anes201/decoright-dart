import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';

// Reusable Circle Avatar with Name below
class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final String name;

  const ProfileAvatar({
    super.key,
    required this.imageUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor:  TColors.primary.withOpacity(0.4),
          child: CircleAvatar(
            radius: 57,
            backgroundImage: NetworkImage(imageUrl),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: TextStyle(
            color: isDark? TColors.light: TColors.dark,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
