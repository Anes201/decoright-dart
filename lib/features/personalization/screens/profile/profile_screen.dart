import 'package:decoright/features/authentication/controllers/auth_controller.dart';
import 'package:decoright/features/authentication/screens/login/login_screen.dart';
import 'package:decoright/features/personalization/controllers/profile_controller.dart';
import 'package:decoright/features/personalization/screens/profile/widgets/profile_avatar.dart';
import 'package:decoright/features/personalization/screens/profile/widgets/profile_info_card.dart';
import 'package:decoright/features/personalization/screens/profile/edit_profile_screen.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:decoright/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final authController = Get.find<AuthController>();

    if (authController.isGuest.value) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.user, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('You are browsing as a Guest'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  authController.signOut(); // Reset state
                  Get.offAll(() => const LoginScreen());
                },
                child: const Text('Log In / Sign Up'),
              ),
            ],
          ),
        ),
      );
    }

    final controller = Get.put(ProfileController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : TColors.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: isDark ? Colors.white : TColors.primary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: controller.refresh,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              children: [
                const SizedBox(height: 40),

                // Profile Avatar
                ProfileAvatar(
                  imageUrl: 'https://ui-avatars.com/api/?name=${controller.fullName}&size=200&background=random',
                  name: controller.fullName,
                ),

                const SizedBox(height: 16),

                // Active since
                Text(
                  controller.activeSince,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? TColors.light : TColors.dark,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 40),

                // Personal Information Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Personal Information',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isDark ? TColors.light : TColors.dark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Get.to(() => const EditProfileScreen());
                      },
                      icon: Icon(
                        Iconsax.edit,
                        color: isDark ? TColors.light : TColors.dark,
                        size: 18,
                      ),
                      label: Text(
                        'Edit',
                        style: TextStyle(
                          color: isDark ? TColors.light : TColors.dark,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Info Cards - using real data from Supabase
                ProfileInfoCard(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: controller.email,
                ),
                ProfileInfoCard(
                  icon: Iconsax.call,
                  label: 'Phone Number',
                  value: controller.phone,
                ),
                ProfileInfoCard(
                  icon: Icons.language,
                  label: 'First Name',
                  value: controller.firstName,
                ),
                ProfileInfoCard(
                  icon: Icons.person_outline,
                  label: 'Last Name',
                  value: controller.lastName,
                ),
                ProfileInfoCard(
                  icon: Icons.workspace_premium,
                  label: 'Role',
                  value: controller.role.capitalize ?? 'Customer',
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
