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
import '../../../../utils/constants/sizes.dart';
import '../../controllers/settings_controller.dart';
import '../profile/profile_screen.dart';
import 'language_selection_page.dart';
import 'activity_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsController controller = Get.put(SettingsController());

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// -- Account Settings
              TSectionHeading(title: l10n.myAccount, showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              
              _buildSettingsContainer(
                isDark,
                children: [
                  SettingsTile(
                    icon: Iconsax.user,
                    title: l10n.personalInformation,
                    subtitle: l10n.completeYourProfile,
                    onTap: () => Get.to(() => ProfileScreen()),
                  ),
                  SettingsTile(
                    icon: Iconsax.activity,
                    title: l10n.activity,
                    onTap: () => Get.to(() => const ActivityScreen()),
                  ),
                ],
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              /// -- App Settings
              TSectionHeading(title: l10n.additional, showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),

              _buildSettingsContainer(
                isDark,
                children: [
                  Obx(
                    () => SettingsTile(
                      icon: Iconsax.moon,
                      title: l10n.theme,
                      subtitle: _getThemeSubtitle(controller.selectedThemeMode.value, context),
                      onTap: () => Get.to(() => ThemeSelectionScreen()),
                    ),
                  ),
                  Obx(
                    () => SettingsTile(
                      icon: Iconsax.language_circle,
                      title: l10n.language,
                      subtitle: _getLanguageName(controller.selectedLanguage.value),
                      onTap: () => Get.to(() => LanguageSelectionScreen()),
                    ),
                  ),
                  SettingsTile(
                    icon: Iconsax.shield_security,
                    title: 'Privacy Policy',
                    onTap: () => Get.to(() => const PrivacyPolicyScreen()),
                  ),
                  SettingsTile(
                    icon: Iconsax.document,
                    title: 'Terms of Service',
                    onTap: () => Get.to(() => const TermsOfServiceScreen()),
                  ),
                  SettingsTile(
                    icon: Iconsax.logout,
                    title: l10n.logout,
                    onTap: () => _handleLogout(context),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsContainer(bool isDark, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? TColors.dark : TColors.light,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(children: children),
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
