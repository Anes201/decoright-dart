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
import 'faq_screen.dart';
import '../../controllers/support_controller.dart';

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
                    onTap: () => Get.to(() => ProfileScreen()),
                  ),
                  SettingsTile(
                    icon: Iconsax.activity,
                    title: l10n.activity,
                    onTap: () => Get.to(() => const ActivityScreen()),
                  ),
                  SettingsTile(
                    icon: Iconsax.support,
                    title: l10n.support,
                    onTap: () => _showSupportBottomSheet(context),
                  ),
                  SettingsTile(
                    icon: Iconsax.message_question,
                    title: 'FAQ',
                    onTap: () => Get.to(() => const FAQScreen()),
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
                    title: l10n.privacyPolicy,
                    onTap: () => Get.to(() => const PrivacyPolicyScreen()),
                  ),
                  SettingsTile(
                    icon: Iconsax.document,
                    title: l10n.termsAndConditions,
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
    final l10n = AppLocalizations.of(context)!;
    
    // Show confirmation dialog
    final shouldLogout = await Get.dialog<bool>(
      AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(l10n.logout),
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
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );

        // Navigate to login screen
        Get.offAll(() => const LoginScreen());
        
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to logout: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      }
    }
  }

  void _showSupportBottomSheet(BuildContext context) {
    final supportController = Get.put(SupportController());
    final isDark = THelperFunctions.isDarkMode(context);
    final l10n = AppLocalizations.of(context)!;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace, vertical: TSizes.md),
        decoration: BoxDecoration(
          color: isDark ? TColors.dark : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// -- Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// -- Title
              Text(
                l10n.supportAndContact,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: TSizes.sm),
              Text(
                l10n.howCanWeHelp,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              
              Obx(() {
                if (supportController.isLoadingLinks.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (supportController.socialLinks.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
                    child: Center(child: Text('No support links available.')),
                  );
                }

                // Separate Direct and Social links
                final directLinks = supportController.socialLinks.entries
                    .where((e) => e.key == 'whatsapp' || e.key == 'phone').toList();
                final socialLinks = supportController.socialLinks.entries
                    .where((e) => e.key != 'whatsapp' && e.key != 'phone').toList();

                return Column(
                  children: [
                    /// -- Direct Contact Section
                    if (directLinks.isNotEmpty) ...[
                      Row(
                        children: directLinks.map((entry) {
                          final isWhatsapp = entry.key == 'whatsapp';
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => supportController.launchSupportUrl(entry.key, entry.value),
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: entry == directLinks.first && directLinks.length > 1 ? TSizes.sm : 0,
                                  left: entry == directLinks.last && directLinks.length > 1 ? TSizes.sm : 0,
                                ),
                                padding: const EdgeInsets.all(TSizes.md),
                                decoration: BoxDecoration(
                                  color: isWhatsapp ? const Color(0xFFE8F8EF) : TColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: (isWhatsapp ? const Color(0xFF25D366) : TColors.primary).withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      isWhatsapp ? Icons.chat : Iconsax.call,
                                      color: isWhatsapp ? const Color(0xFF25D366) : TColors.primary,
                                      size: 32,
                                    ),
                                    const SizedBox(height: TSizes.xs),
                                    Text(
                                      entry.key.capitalizeFirst!,
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isWhatsapp ? const Color(0xFF25D366) : TColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                    ],

                    /// -- Social Media Section
                    if (socialLinks.isNotEmpty) ...[
                      const Divider(),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      Text(
                        l10n.followUs,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: socialLinks.map((entry) {
                          IconData icon;
                          Color color;
                          
                          switch (entry.key) {
                            case 'facebook':
                              icon = Icons.facebook;
                              color = const Color(0xFF1877F2);
                              break;
                            case 'instagram':
                              icon = Iconsax.instagram;
                              color = const Color(0xFFE4405F);
                              break;
                            default:
                              icon = Iconsax.link;
                              color = Colors.grey;
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                            child: IconButton(
                              onPressed: () => supportController.launchSupportUrl(entry.key, entry.value),
                              icon: Icon(icon, color: color, size: 32),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                );
              }),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}
