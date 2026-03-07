import 'package:decoright/features/portfolio/controllers/services_controller.dart';
import 'package:decoright/features/requests/screens/create_request_screen.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:decoright/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:decoright/common/widgets/guest/guest_barrier.dart';
import 'package:decoright/features/authentication/controllers/auth_controller.dart' as decoright_auth;
import 'package:iconsax/iconsax.dart';
import 'package:decoright/l10n/app_localizations.dart';
import 'package:decoright/utils/helpers/helper_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:decoright/utils/loaders/shimmer_loader.dart';

class AllServiceTypesScreen extends StatelessWidget {
  const AllServiceTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServicesController>();
    final i18n = AppLocalizations.of(context)!;
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(title: Text(i18n.servicesWeOffer)),
      body: Obx(() {
        if (controller.services.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.setting,
                  size: 64,
                  color: isDark ? Colors.grey[700] : Colors.grey[400],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(i18n.noServicesFound),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadServices,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            itemCount: controller.services.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: TSizes.spaceBtwItems),
            itemBuilder: (context, index) {
              final service = controller.services[index];
              final locale = Get.locale?.languageCode ?? 'en';
              final title =
                  service['display_name_$locale'] ??
                  service['display_name_en'] ??
                  service['name'];
              final description = service['description'] ?? '';
              final imageUrl = service['image_url'];

              return GestureDetector(
                onTap: () {
                  final authController = Get.find<decoright_auth.AuthController>();
                  if (authController.isGuest.value) {
                    Get.to(() => GuestBarrier(
                      title: i18n.loginToOrder,
                      message: i18n.loginToOrderSubtitle,
                    ));
                  } else {
                    Get.to(() => const CreateRequestScreen());
                  }
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
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
                      /// Image
                      if (imageUrl != null && imageUrl.isNotEmpty)
                        CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const TShimmerEffect(
                            width: 100,
                            height: 100,
                            radius: 0,
                          ),
                          errorWidget:
                              (context, url, error) => Container(
                                width: 100,
                                height: 100,
                                color: TColors.grey.withOpacity(0.1),
                                child: const Icon(Iconsax.image),
                              ),
                        )
                      else
                        Container(
                          width: 100,
                          height: 100,
                          color: TColors.grey.withOpacity(0.1),
                          child: const Icon(Iconsax.image),
                        ),

                      const SizedBox(width: TSizes.spaceBtwItems),

                      /// Info
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: TSizes.sm,
                            horizontal: TSizes.sm,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const Icon(Iconsax.arrow_right_3, size: 16),
                      const SizedBox(width: TSizes.sm),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
