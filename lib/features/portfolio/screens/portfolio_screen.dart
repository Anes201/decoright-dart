import 'package:cached_network_image/cached_network_image.dart';
import 'package:decoright/features/portfolio/controllers/portfolio_controller.dart';
import 'package:decoright/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax/iconsax.dart';

import 'package:decoright/features/personalization/controllers/profile_controller.dart';
import 'package:decoright/features/portfolio/screens/upload_portfolio_screen.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PortfolioController());
    final profileController = Get.put(ProfileController()); // Ensure profile loaded

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Portfolio'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.portfolioItems.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.gallery, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No portfolio items yet'),
              ],
            ),
          );
        }

        return MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: TSizes.gridViewSpacing,
          crossAxisSpacing: TSizes.gridViewSpacing,
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          itemCount: controller.portfolioItems.length,
          itemBuilder: (context, index) {
            final item = controller.portfolioItems[index];
            final imageUrl = item['media_url'] as String?;
            final isVideo = item['media_type'] == 'video';

            return Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      if (imageUrl != null && imageUrl.isNotEmpty)
                        CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 150,
                            color: Colors.grey[200],
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        )
                      else
                        Container(
                          height: 150,
                          color: Colors.grey[200],
                          child: const Center(child: Icon(Iconsax.image, color: Colors.grey)),
                        ),
                      if (isVideo)
                        const Positioned.fill(
                          child: Center(
                            child: Icon(Icons.play_circle_fill, color: Colors.white, size: 48),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] ?? 'Untitled',
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['description'] ?? '',
                          style: Theme.of(context).textTheme.labelSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: Obx(() {
        // Only show button if role is admin
        if (profileController.role == 'admin') {
          return FloatingActionButton(
            onPressed: () async {
              final result = await Get.to(() => const UploadPortfolioScreen());
              if (result == true) {
                controller.loadPortfolio();
              }
            },
            child: const Icon(Iconsax.add),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
