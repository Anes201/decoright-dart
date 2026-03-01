import 'package:decoright/features/requests/screens/create_request_screen.dart';
import 'package:decoright/common/widgets/guest/guest_barrier.dart';
import 'package:decoright/features/authentication/controllers/auth_controller.dart';
import 'package:decoright/features/portfolio/controllers/portfolio_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:decoright/utils/constants/sizes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:decoright/utils/loaders/shimmer_loader.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:decoright/utils/helpers/helper_functions.dart';
import 'package:decoright/l10n/app_localizations.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final title = project['title'] ?? 'Project Detail';
    final description = project['description'] ?? 'No description provided.';
    final imageUrl = project['main_image_url'];
    final serviceType = project['service_type']?.toString().replaceAll('_', ' ') ?? 'Interior Design';
    final location = project['location'] ?? 'Not specified';
    final i18n = AppLocalizations.of(context)!;
    final isDark = THelperFunctions.isDarkMode(context);

    final controller = Get.find<PortfolioController>();
    final projectId = project['id'];
    final currentPage = 0.obs;
    
    // Trigger loading of extra images
    if (projectId != null) {
      controller.loadProjectImages(projectId);
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: isDark ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Project Images Gallery
                Obx(() {
                  final images = controller.projectImages[projectId] ?? [];
                  final isLoading = controller.imagesLoading[projectId] ?? false;
                  
                  final List<String> imageUrls = [];
                  if (imageUrl != null && (imageUrl as String).isNotEmpty) {
                    imageUrls.add(imageUrl);
                  }
                  
                  for (var img in images) {
                    final url = img['image_url'] as String?;
                    if (url != null && url.isNotEmpty && !imageUrls.contains(url)) {
                      imageUrls.add(url);
                    }
                  }

                  if (isLoading && imageUrls.isEmpty) {
                    return const TShimmerEffect(width: double.infinity, height: 450, radius: 0);
                  }

                  if (imageUrls.isEmpty) {
                    return _buildNoImagePlaceholder(context);
                  }

                  return Stack(
                    children: [
                      SizedBox(
                        height: 450,
                        child: PageView.builder(
                          itemCount: imageUrls.length,
                          onPageChanged: (index) => currentPage.value = index,
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: imageUrls[index],
                              width: double.infinity,
                              height: 450,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const TShimmerEffect(width: double.infinity, height: 450, radius: 0),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            );
                          },
                        ),
                      ),
                      
                      /// Page Indicator
                      if (imageUrls.length > 1)
                        Positioned(
                          bottom: 30,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Obx(() => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${currentPage.value + 1} / ${imageUrls.length}",
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            )),
                          ),
                        ),
                        
                      /// Gradient Overlay for better readability of text on image if any
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.transparent,
                                  Colors.transparent,
                                  isDark ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.3),
                                ],
                                stops: const [0.0, 0.2, 0.8, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),

                /// Content Container
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Tag & Title Row
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: TColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                serviceType.toUpperCase(),
                                style: const TextStyle(
                                  color: TColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: TSizes.sm),
                        Text(
                          title,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: TSizes.sm),

                        /// Location
                        Row(
                          children: [
                            const Icon(Iconsax.location5, size: 16, color: TColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              location,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                        
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
                          child: Divider(),
                        ),

                        /// Description Title
                        Text(
                          i18n.aboutProject ?? 'About Project', // Fallback
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),

                        /// Description Content
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                          ),
                        ),
                        
                        const SizedBox(height: 120), // Space for bottom button
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          /// Bottom Fixed Button
          Positioned(
            bottom: TSizes.defaultSpace,
            left: TSizes.defaultSpace,
            right: TSizes.defaultSpace,
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  final authController = AuthController.instance;
                  if (authController.isGuest.value) {
                    Get.to(() => GuestBarrier(
                      title: i18n.loginToOrder,
                      message: i18n.loginToOrderSubtitle,
                    ));
                  } else {
                    Get.to(() => const CreateRequestScreen());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                  shadowColor: TColors.primary.withOpacity(0.4),
                ),
                child: Text(
                  i18n.requestNow,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoImagePlaceholder(BuildContext context) {
    return Container(
      height: 450,
      width: double.infinity,
      color: Colors.grey[200],
      child: const Center(child: Icon(Iconsax.image, size: 64, color: Colors.grey)),
    );
  }
}


