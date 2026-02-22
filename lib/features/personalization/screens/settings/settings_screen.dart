import 'package:decoright/data/services/auth_service.dart';
import 'package:decoright/features/authentication/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:decoright/features/personalization/screens/settings/theme_selection_page.dart';
import 'package:decoright/features/personalization/screens/settings/widgets/settings_tile.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:decoright/utils/helpers/helper_functions.dart';

import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../l10n/app_localizations.dart';
import '../../controllers/settings_controller.dart';
import '../profile/profile_screen.dart';
import 'language_selection_page.dart';
import 'promotions_screen.dart';
import 'favorites_screen.dart';
import 'support_screen.dart';
import 'activity_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';
import 'help_screen.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsController controller = Get.put(SettingsController());

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TSectionHeading(title: AppLocalizations.of(context)!.myAccount),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? TColors.dark : TColors.light,
                  borderRadius: BorderRadius.circular(
                    24,
                  ), // Adjust the radius value as needed
                ),
                child: Column(
                  children: [
                    // profile Tile
                    SettingsTile(
                      icon: Iconsax.user,
                      title: AppLocalizations.of(context)!.personalInformation,
                      subtitle: AppLocalizations.of(
                        context,
                      )!.completeYourProfile,
                      onTap: () => Get.to(() => ProfileScreen()),
                    ),

                    // activity Tile
                    SettingsTile(
                      icon: Iconsax.activity,
                      title: AppLocalizations.of(context)!.activity,
                      onTap: () => Get.to(() => const ActivityScreen()),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 24),
              TSectionHeading(title: AppLocalizations.of(context)!.explore),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? TColors.dark : TColors.light,
                  borderRadius: BorderRadius.circular(
                    24,
                  ), // Adjust the radius value as needed
                ),
                child: Column(
                  children: [
                    SettingsTile(
                      icon: Iconsax.percentage_circle,
                      title: AppLocalizations.of(context)!.promotions,
                      onTap: () => Get.to(() => const PromotionsScreen()),
                    ),

                    SettingsTile(
                      icon: Iconsax.star,
                      title: AppLocalizations.of(context)!.favorites,
                      onTap: () => Get.to(() => const FavoritesScreen()),
                    ),

                    // Support Tile
                    SettingsTile(
                      icon: Iconsax.message_2,
                      title: AppLocalizations.of(context)!.support,
                      onTap: () => Get.to(() => const SupportScreen()),
                    ),

                    // Help Tile
                    SettingsTile(
                      icon: Iconsax.info_circle,
                      title: 'Help Center',
                      onTap: () => Get.to(() => const HelpScreen()),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              TSectionHeading(title: AppLocalizations.of(context)!.additional),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? TColors.dark : TColors.light,
                  borderRadius: BorderRadius.circular(
                    24,
                  ), // Adjust the radius value as needed
                ),
                child: Column(
                  children: [
                    // Theme Tile
                    Obx(
                      () => SettingsTile(
                        icon: Iconsax.moon,
                        title: AppLocalizations.of(context)!.theme,
                        subtitle: _getThemeSubtitle(
                          controller.selectedThemeMode.value,
                          context,
                        ),
                        onTap: () => Get.to(() => ThemeSelectionScreen()),
                      ),
                    ),

                    // Language Tile
                    Obx(
                      () => SettingsTile(
                        icon: Iconsax.language_circle,
                        title: AppLocalizations.of(context)!.language,
                        subtitle: _getLanguageName(
                          controller.selectedLanguage.value,
                        ),
                        onTap: () => Get.to(() => LanguageSelectionScreen()),
                      ),
                    ),

                    // Privacy Policy Tile
                    SettingsTile(
                      icon: Iconsax.shield_security,
                      title: 'Privacy Policy',
                      onTap: () => Get.to(() => const PrivacyPolicyScreen()),
                    ),

                    // Terms of Service Tile
                    SettingsTile(
                      icon: Iconsax.document,
                      title: 'Terms of Service',
                      onTap: () => Get.to(() => const TermsOfServiceScreen()),
                    ),

                    // logout Tile
                    SettingsTile(
                      icon: Iconsax.logout,
                      title: AppLocalizations.of(context)!.logout,
                      onTap: () => _handleLogout(context),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              TSectionHeading(title: AppLocalizations.of(context)!.additional),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? TColors.dark : TColors.light,
                  borderRadius: BorderRadius.circular(
                    24,
                  ), // Adjust the radius value as needed
                ),
                child: Column(
                  children: [
                    // Theme Tile
                    Obx(
                      () => SettingsTile(
                        icon: Iconsax.moon,
                        title: AppLocalizations.of(context)!.theme,
                        subtitle: _getThemeSubtitle(
                          controller.selectedThemeMode.value,
                          context,
                        ),
                        onTap: () => Get.to(() => ThemeSelectionScreen()),
                      ),
                    ),

                    // Language Tile
                    Obx(
                      () => SettingsTile(
                        icon: Iconsax.language_circle,
                        title: AppLocalizations.of(context)!.language,
                        subtitle: _getLanguageName(
                          controller.selectedLanguage.value,
                        ),
                        onTap: () => Get.to(() => LanguageSelectionScreen()),
                      ),
                    ),

                    // logout Tile
                    SettingsTile(
                      icon: Iconsax.logout,
                      title: AppLocalizations.of(context)!.logout,
                      onTap: () => _handleLogout(context),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getThemeSubtitle(ThemeMode mode, context) {
    switch (mode) {
      case ThemeMode.light:
        return AppLocalizations.of(context)!.lightMode;
      case ThemeMode.dark:
        return AppLocalizations.of(context)!.darkMode;
      default:
        return AppLocalizations.of(context)!.followSystem;
    }
  }



  String _getLanguageName(String code) {
    switch (code) {
      case "en":
        return "English";
      case "fr":
        return "Français";
      case "ar":
        return "العربية";
      default:
        return "Unknown";
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    final authService = AuthService();
    
    // Show confirmation dialog
    final shouldLogout = await Get.dialog<bool>(
      AlertDialog(
        title: Text(AppLocalizations.of(context)!.logout),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        await authService.signOut();
        
        Get.snackbar(
          'Success',
          'Logged out successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );

        // Navigate to login screen
        Get.offAll(() => const LoginScreen());
        
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to logout: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
    }
  }
}
