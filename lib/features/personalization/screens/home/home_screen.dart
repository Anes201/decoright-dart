import 'package:cached_network_image/cached_network_image.dart';
import 'package:decoright/navigation_menu.dart';
import 'package:decoright/features/personalization/controllers/profile_controller.dart';
import 'package:decoright/common/widgets/guest/guest_barrier.dart';
import 'package:decoright/features/authentication/controllers/auth_controller.dart';
import 'package:decoright/features/portfolio/controllers/portfolio_controller.dart';
import 'package:decoright/features/portfolio/controllers/space_types_controller.dart';
import 'package:decoright/features/portfolio/screens/project_detail_screen.dart'; // Added import
import 'package:decoright/features/portfolio/screens/all_space_types_screen.dart';
import 'package:decoright/features/portfolio/screens/all_service_types_screen.dart';
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
    final spaceTypesController = Get.put(SpaceTypesController());
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
              spaceTypesController.loadSpaceTypes(),
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
                    _buildSectionHeader(context, i18n.servicesWeOffer, () {
                      Get.to(() => const AllServiceTypesScreen());
                    }, i18n),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Obx(() {
                      if (servicesController.isLoading.value) {
                        return SizedBox(
                          height: 200,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            separatorBuilder: (_, __) => const SizedBox(width: TSizes.spaceBtwItems),
                            itemBuilder: (_, __) => const TShimmerEffect(width: 250, height: 200),
                          ),
                        );
                      }
                      
                      if (servicesController.services.isEmpty) {
                        return Center(child: Text(i18n.noServicesFound));
                      }
  
                      return SizedBox(
                        height: 220,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: servicesController.services.length > 5 ? 5 : servicesController.services.length,
                          separatorBuilder: (_, __) => const SizedBox(width: TSizes.spaceBtwItems),
                          itemBuilder: (context, index) {
                            final service = servicesController.services[index];
                            return SizedBox(
                              width: 260,
                              child: _buildServiceCardHorizontal(context, service, i18n),
                            );
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    
                    /// Space Types Section (New)
                    _buildSectionHeader(context, i18n.spaceTypes, () {
                      Get.to(() => const AllSpaceTypesScreen());
                    }, i18n),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    
                    Obx(() {
                      if (spaceTypesController.isLoading.value) {
                        return SizedBox(
                          height: 120,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            separatorBuilder: (_, __) => const SizedBox(width: TSizes.spaceBtwItems),
                            itemBuilder: (_, __) => const TShimmerEffect(width: 150, height: 120),
                          ),
                        );
                      }
                      
                      if (spaceTypesController.spaceTypes.isEmpty) {
                        return Center(child: Text(i18n.noSpaceTypesFound));
                      }
  
                      return SizedBox(
                        height: 190,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: spaceTypesController.spaceTypes.length > 6 ? 6 : spaceTypesController.spaceTypes.length,
                          separatorBuilder: (_, __) => const SizedBox(width: TSizes.spaceBtwItems),
                          itemBuilder: (context, index) {
                            final space = spaceTypesController.spaceTypes[index];
                            final locale = Get.locale?.languageCode ?? 'en';
                            final title = space['display_name_$locale'] ?? space['display_name_en'] ?? space['name'] ?? '';

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

                            final List images = space['space_type_images'] ?? [];
                            String? imageUrl;
                            if (images.isNotEmpty) {
                              images.sort((a, b) => (a['sort_order'] ?? 0).compareTo(b['sort_order'] ?? 0));
                              imageUrl = images.first['image_url'];
                            }

                            return GestureDetector(
                              onTap: () => Get.to(() => const AllSpaceTypesScreen()),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                                child: Container(
                                  width: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                                    color: isDark ? const Color(0xFF272727) : Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.07),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Image covering top
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(TSizes.cardRadiusLg)),
                                        child: imageUrl != null && imageUrl.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl: imageUrl,
                                                height: 110,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => const TShimmerEffect(width: double.infinity, height: 110, radius: 0),
                                                errorWidget: (context, url, error) => _buildSpaceImagePlaceholder(getIconForSpace(space['name'] ?? ''), isDark),
                                              )
                                            : _buildSpaceImagePlaceholder(getIconForSpace(space['name'] ?? ''), isDark),
                                      ),
                                      // Title at bottom
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.xs),
                                          child: Center(
                                            child: Text(
                                              title,
                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
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

  Widget _buildServiceCardHorizontal(BuildContext context, Map<String, dynamic> service, AppLocalizations i18n) {
    final isDark = THelperFunctions.isDarkMode(context);
    final locale = Get.locale?.languageCode ?? 'en';
    final displayName = service['display_name_$locale'] ?? service['display_name_en'] ?? service['name'];
    final imageUrl = service['image_url'];

    return GestureDetector(
      onTap: () {
        final authController = AuthController.instance;
        if (authController.isGuest.value) {
          Get.to(() => GuestBarrier(title: i18n.loginToOrder, message: i18n.loginToOrderSubtitle));
        } else {
          Get.to(() => const CreateRequestScreen());
        }
      },
      child: Container(
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
            /// Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(TSizes.cardRadiusLg)),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const TShimmerEffect(width: double.infinity, height: 140, radius: 0),
                      errorWidget: (context, url, error) => _buildNoImagePlaceholder(context, isDark, i18n),
                    )
                  : _buildNoImagePlaceholder(context, isDark, i18n),
            ),
            /// Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
              child: Text(
                displayName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, ProfileController profileController, AppLocalizations i18n) {
    final isDark = THelperFunctions.isDarkMode(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1A1A2E), const Color(0xFF16213E), TColors.primary.withOpacity(0.7)]
              : [const Color(0xFF3D5A80), TColors.primary, const Color(0xFF5E81AC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            screenWidth * 0.06,
            20,
            screenWidth * 0.06,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: greeting + notification icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Obx(() {
                      final name = profileController.firstName;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            i18n.welcomeBack,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.75),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            name.isNotEmpty ? name : 'DecoRight',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
                    }),
                  ),
                  // Decoration icon pill
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Iconsax.home_2, color: Colors.white, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Tagline
              Text(
                i18n.onboarding1title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.88),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
              // CTA Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final authController = AuthController.instance;
                    if (authController.isGuest.value) {
                      Get.to(() => GuestBarrier(title: i18n.loginToOrder, message: i18n.loginToOrderSubtitle));
                    } else {
                      Get.to(() => const CreateRequestScreen());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: TColors.primary,
                    elevation: 0,
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Iconsax.magicpen, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        i18n.requestAService,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
            onPressed: () {
              final authController = AuthController.instance;
              if (authController.isGuest.value) {
                Get.to(() => GuestBarrier(
                  title: i18n.loginToViewHome, // Or more specific if needed
                  message: i18n.loginToViewHomeSubtitle,
                ));
              } else {
                onTap();
              }
            },
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
      onTap: () {
        final authController = AuthController.instance;
        if (authController.isGuest.value) {
          Get.to(() => GuestBarrier(title: i18n.loginToOrder, message: i18n.loginToOrderSubtitle));
        } else {
          Get.to(() => const CreateRequestScreen());
        }
      },
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
                      onPressed: () {
                        final authController = AuthController.instance;
                        if (authController.isGuest.value) {
                          Get.to(() => GuestBarrier(title: i18n.loginToOrder, message: i18n.loginToOrderSubtitle));
                        } else {
                          Get.to(() => const CreateRequestScreen());
                        }
                      },
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
    
    // Find imageUrl: check main_image_url first, then join data
    String? imageUrl = item['main_image_url'] as String?;
    if (imageUrl == null || imageUrl.isEmpty) {
      final List images = item['project_images'] ?? [];
      final coverImg = images.firstWhereOrNull((img) => img['is_cover'] == true);
      imageUrl = coverImg?['image_url'] ?? (images.isNotEmpty ? images.first['image_url'] : null);
    }
    
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

  Widget _buildIconPlaceholder(IconData iconData, bool isDark) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : TColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
      ),
      child: Center(
        child: Icon(
          iconData,
          color: TColors.primary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildSpaceImagePlaceholder(IconData iconData, bool isDark) {
    return Container(
      height: 110,
      width: double.infinity,
      color: isDark ? const Color(0xFF1E1E2E) : TColors.primary.withOpacity(0.08),
      child: Center(
        child: Icon(iconData, size: 36, color: TColors.primary.withOpacity(0.5)),
      ),
    );
  }
}
