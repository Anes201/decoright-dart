import 'package:decoright/features/portfolio/screens/widgets/before_after_widget.dart';
import 'package:decoright/features/portfolio/controllers/portfolio_controller.dart';
import 'package:decoright/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:decoright/features/personalization/controllers/profile_controller.dart';
import 'package:decoright/features/portfolio/screens/upload_portfolio_screen.dart';
import 'package:decoright/utils/helpers/helper_functions.dart';
import 'package:decoright/utils/loaders/shimmer_loader.dart';
import 'package:decoright/l10n/app_localizations.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PortfolioController());
    final profileController = Get.put(ProfileController()); // Ensure profile loaded
    final i18n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.interiorGallery),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView.separated(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwSections),
            itemBuilder: (_, __) => const TShimmerEffect(width: double.infinity, height: 350),
          );
        }

        if (controller.galleryItems.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.loadGalleryItems,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.gallery, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(i18n.noGalleryItems),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadGalleryItems,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            itemCount: controller.galleryItems.length,
          separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwSections),
          itemBuilder: (context, index) {
            final isDark = THelperFunctions.isDarkMode(context);
            final item = controller.galleryItems[index];
            final beforeUrl = item['before_image_url'] as String?;
            final afterUrl = item['after_image_url'] as String?;
            final title = item['title'] ?? 'Untitled Transform';
            final description = item['description'] ?? '';

            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                color: isDark ? const Color(0xFF272727) : Colors.white, // TColors.darkContainer usually
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Before/After Viewer
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(TSizes.cardRadiusLg)),
                    child: beforeUrl != null && afterUrl != null
                        ? BeforeAfterWidget(
                            beforeImage: beforeUrl,
                            afterImage: afterUrl,
                            height: 250,
                          )
                        : _buildNoImagePlaceholder(context, isDark, i18n),
                  ),

                  /// Info Section
                  Padding(
                    padding: const EdgeInsets.all(TSizes.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (description.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
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
      floatingActionButton: Obx(() {
        // Only show button if role is admin
        if (profileController.role == 'admin') {
          return FloatingActionButton(
            onPressed: () async {
              final result = await Get.to(() => const UploadPortfolioScreen());
              if (result == true) {
                controller.loadAll(); // Changed to loadAll for consistency
              }
            },
            child: const Icon(Iconsax.add),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Widget _buildNoImagePlaceholder(BuildContext context, bool isDark, AppLocalizations i18n) {
    return Container(
      height: 200,
      width: double.infinity,
      color: isDark ? Colors.grey[900] : Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.image, size: 48, color: isDark ? Colors.grey[700] : Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            i18n.noFeaturedProjects,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
