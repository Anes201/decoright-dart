import 'package:decoright/core/config/supabase_config.dart';
import 'package:decoright/data/services/auth_service.dart';
import 'package:decoright/features/personalization/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:decoright/utils/helpers/helper_functions.dart';
import 'package:decoright/common/widgets/appbar/appbar.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final isDark = THelperFunctions.isDarkMode(context);
    
    // Controllers for form fields
    final firstNameController = TextEditingController(text: controller.firstName);
    final lastNameController = TextEditingController(text: controller.lastName);
    final emailController = TextEditingController(text: controller.email);
    final phoneController = TextEditingController(text: controller.phone);

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Edit Profile'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              // Save profile changes
              try {
                // Update profile in Supabase
                final authService = AuthService();
                final userId = controller.currentUser.value?.id;
                if (userId != null) {
                  await SupabaseConfig.client.from('profiles').update({
                    'full_name': '${firstNameController.text} ${lastNameController.text}',
                    'phone': phoneController.text,
                  }).eq('id', userId);
                  
                  await controller.refresh();
                }
                
                Get.back(result: true);
                Get.snackbar(
                  'Success',
                  'Profile updated successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green.withOpacity(0.1),
                  colorText: Colors.green,
                );
              } catch (e) {
                String errorMessage = e.toString();
                if (errorMessage.contains('23505') || errorMessage.toLowerCase().contains('duplicate') || errorMessage.toLowerCase().contains('unique constraint')) {
                  errorMessage = 'This phone number is already in use by another account.';
                }

                Get.snackbar(
                  'Error',
                  'Failed to update profile: $errorMessage',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.withOpacity(0.1),
                  colorText: Colors.red,
                );
              }
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: isDark ? TColors.light : TColors.dark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile picture section
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? TColors.darkGrey : TColors.lightGrey,
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://ui-avatars.com/api/?name=${controller.fullName}&size=200&background=random',
                        ),
                        radius: 60,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: TColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? TColors.dark : TColors.light,
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          Iconsax.camera,
                          color: TColors.light,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Form fields
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? TColors.light : TColors.dark,
                ),
              ),
              const SizedBox(height: 16),
              
              // First Name Field
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Iconsax.user),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Last Name Field
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Iconsax.user),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Email Field
              TextField(
                controller: emailController,
                enabled: false, // Email typically can't be changed directly
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Iconsax.sms),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? TColors.darkGrey : TColors.lightGrey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Phone Field
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Iconsax.call),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              
              // Additional profile options
              Text(
                'Account Settings',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? TColors.light : TColors.dark,
                ),
              ),
              const SizedBox(height: 16),
              
              // Change Password Option
              Card(
                color: isDark ? TColors.darkGrey : TColors.lightGrey,
                child: ListTile(
                  leading: Icon(
                    Iconsax.password_check,
                    color: isDark ? TColors.primary : TColors.primary,
                  ),
                  title: Text('Change Password'),
                  trailing: Icon(Iconsax.arrow_right_3),
                  onTap: () {
                    // Navigate to change password screen
                    Get.snackbar(
                      'Coming Soon',
                      'Change password functionality coming soon!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      colorText: Colors.blue,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}