import 'package:cached_network_image/cached_network_image.dart';
import 'package:decoright/navigation_menu.dart';
import 'package:decoright/features/personalization/controllers/profile_controller.dart';
import 'package:decoright/features/portfolio/controllers/portfolio_controller.dart';
import 'package:decoright/features/portfolio/screens/project_detail_screen.dart'; // Added import
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
                  /// Status Shortcut: Active Projects
                  Obx(() {
                    if (requestController.requests.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(context, "Active Projects", () {
                            // Navigate to requests tab (Index 2)
                            final nav = Get.find<NavigationController>();
                            nav.selectedIndex.value = 2;
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
                  _buildSectionHeader(context, "Featured Projects", () {
                    // Navigate to Gallery tab (Index 1)
                    final nav = Get.find<NavigationController>();
                    nav.selectedIndex.value = 1;
                  }),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  
                  Obx(() {
                    if (portfolioController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (portfolioController.projects.isEmpty) {
                      return const Center(child: Text("No featured projects yet."));
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: portfolioController.projects.length > 5 ? 5 : portfolioController.projects.length,
                      separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                      itemBuilder: (context, index) {
                        final item = portfolioController.projects[index];
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
                  Text("Request a Service", style: TextStyle(fontWeight: FontWeight.bold)),
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
    final serviceTypeData = request['service_types'];
    final serviceType = ((serviceTypeData is Map ? serviceTypeData['name'] : request['service_type']) ?? 'Service')
        .toString()
        .replaceAll('_', ' ');

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
        title: Text(serviceType.toString().replaceAll('_', ' ')),
        subtitle: Text("Status: $status"),
        trailing: const Icon(Iconsax.arrow_right_3, size: 18),
        onTap: () {
          // Navigate to request details or chat
        },
      ),
    );
  }

  Widget _buildPortfolioCard(BuildContext context, Map<String, dynamic> item) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final imageUrl = item['main_image_url'] as String?;
    final title = item['title'] ?? 'Untitled Project';
    final service = item['service_type']?.toString().replaceAll('_', ' ') ?? 'Interior';

    return GestureDetector(
      onTap: () => Get.to(() => ProjectDetailScreen(project: item)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          color: isDark ? TColors.darkContainer : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Project Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(TSizes.cardRadiusLg)),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 200,
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => _buildNoImagePlaceholder(isDark),
                    )
                  : _buildNoImagePlaceholder(isDark),
            ),

            /// Project Info
            Padding(
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Iconsax.arrow_right_3, size: 18),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: TColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoImagePlaceholder(bool isDark) {
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
            "No images presented",
            style: TextStyle(
              color: isDark ? Colors.grey[600] : Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
