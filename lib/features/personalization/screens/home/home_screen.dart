import 'package:cached_network_image/cached_network_image.dart';
import 'package:decoright/features/personalization/controllers/profile_controller.dart';
import 'package:decoright/features/portfolio/controllers/portfolio_controller.dart';
import 'package:decoright/features/requests/controllers/request_controller.dart';
import 'package:decoright/features/requests/screens/create_request_screen.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:decoright/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolioController = Get.put(PortfolioController());
    final requestController = Get.put(RequestController());
    final profileController = Get.find<ProfileController>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Hero Section / Intro
            _buildHeroSection(context, profileController),

            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Status Shortcut: Your Requests (if any)
                  Obx(() {
                    if (requestController.requests.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(context, "Your Requests", () {
                            // Navigate to requests tab or screen
                          }),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          _buildRecentRequestCard(context, requestController.requests.first),
                          const SizedBox(height: TSizes.spaceBtwSections),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  /// Portfolio Highlights / Featured Projects
                  _buildSectionHeader(context, "Featured Projects", null),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  
                  Obx(() {
                    if (portfolioController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (portfolioController.portfolioItems.isEmpty) {
                      return const Center(child: Text("No featured projects yet."));
                    }

                    return MasonryGridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: TSizes.gridViewSpacing,
                      crossAxisSpacing: TSizes.gridViewSpacing,
                      itemCount: portfolioController.portfolioItems.length > 4 
                          ? 4 
                          : portfolioController.portfolioItems.length,
                      itemBuilder: (context, index) {
                        final item = portfolioController.portfolioItems[index];
                        return _buildPortfolioCard(context, item);
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, ProfileController profileController) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 60,
        left: TSizes.defaultSpace,
        right: TSizes.defaultSpace,
        bottom: 30,
      ),
      decoration: const BoxDecoration(
        color: TColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(
                "Hi, ${profileController.firstName}!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
              )),
          const SizedBox(height: 8),
          Text(
            "Start designing your space",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          
          /// Primary CTA: Request a Design
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.to(() => const CreateRequestScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: TColors.primary,
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.magicpen),
                  SizedBox(width: 8),
                  Text("Request a Design", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback? onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (onTap != null)
          TextButton(
            onPressed: onTap,
            child: const Text("See All"),
          ),
      ],
    );
  }

  Widget _buildRecentRequestCard(BuildContext context, Map<String, dynamic> request) {
    final status = request['status'] ?? 'Unknown';
    final serviceType = request['service_type'] ?? 'Service';

    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: TColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Iconsax.note_1, color: TColors.primary),
        ),
        title: Text(serviceType),
        subtitle: Text("Status: $status"),
        trailing: const Icon(Iconsax.arrow_right_3, size: 18),
        onTap: () {
          // Navigate to request details or chat
        },
      ),
    );
  }

  Widget _buildPortfolioCard(BuildContext context, Map<String, dynamic> item) {
    final imageUrl = item['media_url'] as String?;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null && imageUrl.isNotEmpty)
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(height: 100, color: Colors.grey[200]),
            )
          else
            Container(height: 100, color: Colors.grey[200], child: const Icon(Iconsax.image)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item['title'] ?? 'Untitled',
              style: Theme.of(context).textTheme.labelLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
