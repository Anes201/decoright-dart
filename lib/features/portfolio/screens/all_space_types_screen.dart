import 'package:decoright/features/portfolio/controllers/space_types_controller.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:decoright/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:decoright/l10n/app_localizations.dart';
import 'package:decoright/utils/helpers/helper_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:decoright/utils/loaders/shimmer_loader.dart';

class AllSpaceTypesScreen extends StatelessWidget {
  const AllSpaceTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller is initialized in HomeScreen, so we just find it.
    final controller = Get.find<SpaceTypesController>();
    final i18n = AppLocalizations.of(context)!;
    final isDark = THelperFunctions.isDarkMode(context);

    // Dynamic icon mapper because space_types table has no icon url natively.
    IconData getIconForSpace(String name) {
      final n = name.toLowerCase();
      if (n.contains("living")) return Iconsax.home;
      if (n.contains("bed")) return Iconsax.moon;
      if (n.contains("kitchen")) return Iconsax.cake;
      if (n.contains("bath")) return Iconsax.drop;
      if (n.contains("office") || n.contains("work")) return Iconsax.briefcase;
      if (n.contains("outdoor") || n.contains("garden")) return Iconsax.tree;
      return Iconsax.category;
    }

    return Scaffold(
      appBar: AppBar(title: Text(i18n.spaceTypes)),
      body: Obx(() {
        if (controller.spaceTypes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.category,
                  size: 64,
                  color: isDark ? Colors.grey[700] : Colors.grey[400],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(i18n.noSpaceTypesFound),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadSpaceTypes,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            itemCount: controller.spaceTypes.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: TSizes.spaceBtwItems),
            itemBuilder: (context, index) {
              final space = controller.spaceTypes[index];
              final locale = Get.locale?.languageCode ?? 'en';
              final title =
                  space['display_name_$locale'] ??
                  space['display_name_en'] ??
                  space['name'];
              final description = space['description'] ?? '';
              
              final List images = space['space_type_images'] ?? [];
              String? imageUrl;
              if (images.isNotEmpty) {
                images.sort((a, b) => (a['sort_order'] ?? 0).compareTo(b['sort_order'] ?? 0));
                imageUrl = images.first['image_url'];
              }

              return Container(
                padding: const EdgeInsets.all(TSizes.md),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                  color: isDark ? const Color(0xFF272727) : Colors.white,
                  border: Border.all(
                    color: isDark
                        ? TColors.darkGrey
                        : TColors.grey.withOpacity(0.3),
                  ),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    if (imageUrl != null && imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const TShimmerEffect(width: 80, height: 80, radius: TSizes.cardRadiusMd),
                          errorWidget: (context, url, error) => _buildIconPlaceholder(getIconForSpace(space['name'] ?? ''), isDark),
                        ),
                      )
                    else
                      _buildIconPlaceholder(getIconForSpace(space['name'] ?? ''), isDark),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              description,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildIconPlaceholder(IconData iconData, bool isDark) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : TColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
      ),
      child: Center(
        child: Icon(
          iconData,
          color: TColors.primary,
          size: 32,
        ),
      ),
    );
  }
}
