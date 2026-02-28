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
import 'package:decoright/l10n/app_localizations.dart';
import 'package:decoright/features/portfolio/controllers/services_controller.dart';
import 'package:decoright/utils/loaders/shimmer_loader.dart';
import 'package:decoright/utils/helpers/helper_functions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolioController = Get.put(PortfolioController());
    final servicesController = Get.put(ServicesController());
    final requestController = Get.put(RequestController());
    final profileController = Get.find<ProfileController>();
    final i18n = AppLocalizations.of(context)!;
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              portfolioController.loadProjects(),
              servicesController.loadServices(),
              requestController.loadRequests(),
            ]);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Hero Section / Intro
              _buildHeroSection(context, profileController, i18n),
  
              Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Status Shortcut: Active Projects
                    Obx(() {
                      if (requestController.isLoading.value) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TShimmerEffect(width: 150, height: 20),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            const TShimmerEffect(width: double.infinity, height: 100),
                            const SizedBox(height: TSizes.spaceBtwSections),
                          ],
                        );
                      }
                      if (requestController.requests.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader(context, i18n.activeProjects, () {
                              final nav = Get.find<NavigationController>();
                              nav.selectedIndex.value = 2;
                            }, i18n),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            _buildRecentRequestCard(context, requestController.requests.first),
                            const SizedBox(height: TSizes.spaceBtwSections),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
  
                    /// Services We Offer Section
                    _buildSectionHeader(context, i18n.servicesWeOffer, null, i18n),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Obx(() {
                      if (servicesController.isLoading.value) {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                          itemBuilder: (_, __) => const TShimmerEffect(width: double.infinity, height: 120),
                        );
                      }
                      
                      if (servicesController.services.isEmpty) {
                        return Center(child: Text(i18n.noServicesFound));
                      }
  
                    return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: servicesController.services.length,
                        separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                        itemBuilder: (context, index) {
                          final service = servicesController.services[index];
                          return _buildServiceCard(context, service, i18n);
                        },
                      );
                    }),
                    const SizedBox(height: TSizes.spaceBtwSections),
  
                    /// Portfolio Highlights / Featured Projects
                    _buildSectionHeader(context, i18n.featuredProjects, () {
                      final nav = Get.find<NavigationController>();
                      nav.selectedIndex.value = 1;
                    }, i18n),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    
                    Obx(() {
                      if (portfolioController.isLoading.value) {
                        return SizedBox(
                          height: 240,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            separatorBuilder: (_, __) => const SizedBox(width: TSizes.spaceBtwItems),
                            itemBuilder: (_, __) => const TShimmerEffect(width: 300, height: 240),
                          ),
                        );
                      }
                      
                      if (portfolioController.projects.isEmpty) {
                        return SizedBox(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Iconsax.folder_open, size: 48, color: isDark ? Colors.grey[700] : Colors.grey[400]),
                                const SizedBox(height: TSizes.sm),
                                Text(i18n.noFeaturedProjects),
                              ],
                            ),
                          ),
                        );
                      }
  
                      return SizedBox(
                        height: 240,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: portfolioController.projects.length > 4 ? 4 : portfolioController.projects.length,
                          separatorBuilder: (_, __) => const SizedBox(width: TSizes.spaceBtwItems),
                          itemBuilder: (context, index) {
                            final item = portfolioController.projects[index];
                             return SizedBox(
                               width: 280,
                               child: _buildPortfolioCard(context, item),
                             );
                           },
                         ),
                       );
                     }),
                  ],
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, ProfileController profileController, AppLocalizations i18n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 40,
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
                "${i18n.welcomeBack} ${profileController.firstName}!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
              )),
          const SizedBox(height: 8),
          Text(
            i18n.onboarding1title,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.magicpen, size: 20),
                  const SizedBox(width: 8),
                  Text(i18n.requestAService, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback? onTap, AppLocalizations i18n) {
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
            child: Text(i18n.viewAll),
          ),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, Map<String, dynamic> service, AppLocalizations i18n) {
    final isDark = THelperFunctions.isDarkMode(context);
    final locale = Get.locale?.languageCode ?? 'en';
    final displayName = service['display_name_$locale'] ?? service['display_name_en'] ?? service['name'];
    final imageUrl = service['image_url'];
    final description = service['description'] ?? '';

    return GestureDetector(
      onTap: () => Get.to(() => const CreateRequestScreen()),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          color: isDark ? TColors.darkContainer : Colors.white,
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
            /// Service Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(TSizes.cardRadiusLg)),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const TShimmerEffect(
                        width: double.infinity,
                        height: 180,
                        radius: 0,
                      ),
                      errorWidget: (context, url, error) => _buildNoImagePlaceholder(context, isDark, i18n),
                    )
                  : _buildNoImagePlaceholder(context, isDark, i18n),
            ),

            /// Service Info
            Padding(
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: TSizes.spaceBtwItems),
                  
                  /// Request Now Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Get.to(() => const CreateRequestScreen()),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: TColors.primary),
                        foregroundColor: isDark ? Colors.white : TColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(i18n.requestNow, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentRequestCard(BuildContext context, Map<String, dynamic> request) {
    final i18n = AppLocalizations.of(context)!;
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
        subtitle: Text("${i18n.activity}: $status"),
        trailing: const Icon(Iconsax.arrow_right_3, size: 18),
        onTap: () {
          // Navigate to request details or chat
        },
      ),
    );
  }

  Widget _buildPortfolioCard(BuildContext context, Map<String, dynamic> item) {
    final i18n = AppLocalizations.of(context)!;
    final isDark = THelperFunctions.isDarkMode(context);
    final imageUrl = item['main_image_url'] as String?;
    final title = item['title'] ?? 'Untitled Project';
    final service = item['service_type']?.toString().replaceAll('_', ' ') ?? 'Interior';

    return GestureDetector(
      onTap: () => Get.to(() => ProjectDetailScreen(project: item)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            color: isDark ? const Color(0xFF272727) : Colors.white,
            border: isDark ? Border.all(color: Colors.grey.withOpacity(0.1)) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Project Image
              imageUrl != null && imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 155,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const TShimmerEffect(
                        width: double.infinity,
                        height: 155,
                        radius: 0,
                      ),
                      errorWidget: (context, url, error) =>
                          _buildNoImagePlaceholder(context, isDark, i18n),
                    )
                  : _buildNoImagePlaceholder(context, isDark, i18n),

              /// Project Info
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.md, vertical: TSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
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
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: TColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoImagePlaceholder(BuildContext context, bool isDark, AppLocalizations i18n) {
    return Container(
      height: 155, // Matched with the actual image height to prevent overflow
      width: double.infinity,
      color: isDark ? const Color(0xFF1E1E1E) : TColors.grey.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.image, size: 40, color: isDark ? Colors.grey[700] : Colors.grey[400]),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
            child: Text(
              i18n.noPicturesForProject,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.grey[600] : Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
