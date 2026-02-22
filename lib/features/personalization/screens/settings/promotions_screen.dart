import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:decoright/utils/helpers/helper_functions.dart';
import 'package:decoright/common/widgets/appbar/appbar.dart';

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Promotions'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Special Offers & Promotions',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? TColors.light : TColors.dark,
              ),
            ),
            const SizedBox(height: 24),
            
            // Empty state or promotions list
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.discount_shape,
                      size: 80,
                      color: isDark ? TColors.grey : TColors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No active promotions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isDark ? TColors.lightGrey : TColors.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check back later for special offers',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? TColors.grey : TColors.grey,
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
}