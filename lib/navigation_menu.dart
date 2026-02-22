// lib/navigation_menu.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:decoright/l10n/app_localizations.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:decoright/utils/helpers/helper_functions.dart';

import 'features/personalization/screens/settings/settings_screen.dart';
import 'features/portfolio/screens/portfolio_screen.dart';
import 'features/requests/screens/my_requests_screen.dart';
import 'features/personalization/screens/home/home_screen.dart';

import 'package:decoright/features/authentication/controllers/auth_controller.dart';
import 'package:decoright/common/widgets/guest/guest_barrier.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: isDark ? TColors.dark : TColors.light,
            currentIndex: controller.selectedIndex.value,
            onTap: (index) => controller.selectedIndex.value = index,
            selectedItemColor: TColors.primary,
            unselectedItemColor: isDark ? Colors.white70 : Colors.grey,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Iconsax.home),
                label: AppLocalizations.of(context)!.home,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Iconsax.calendar),
                label: AppLocalizations.of(context)!.order,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Iconsax.setting),
                label: AppLocalizations.of(context)!.settings,
              ),
            ],
          );
        },
      ),
      body: Obx(
        () => controller.screens[controller.selectedIndex.value],
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final authController = Get.find<AuthController>();

  // Define your actual screens here
  late final List<Widget> screens;

  @override
  void onInit() {
    super.onInit();

    final isGuest = authController.isGuest.value;

    // Initialize screens list
    if (isGuest) {
      screens = [
        const HomeScreen(),
        const GuestBarrier(
          title: 'Login to Order',
          message: 'You need to be logged in to submit service requests.',
        ),
        const GuestBarrier(
          title: 'Login to Settings',
          message: 'You need to be logged in to view and change settings.',
        ),
      ];
    } else {
      screens = [
        const HomeScreen(),                 // New Home Screen
        const MyRequestsScreen(),                 // Service Requests
        SettingsScreen(),                    // Settings
      ];
    }
  }
}