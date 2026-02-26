import 'package:decoright/features/authentication/controllers/forgot_password_controller.dart';
import 'package:decoright/utils/constants/sizes.dart';
import 'package:decoright/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../l10n/app_localizations.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final controller = ForgotPasswordController.instance;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(t.changeYourPasswordTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your new password below.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              Form(
                key: controller.newPasswordFormKey,
                child: Column(
                  children: [
                    // New Password
                    Obx(() => TextFormField(
                      controller: controller.newPasswordController,
                      validator: (value) => TValidator.validatePassword(value),
                      obscureText: controller.hideNewPassword.value,
                      decoration: InputDecoration(
                        labelText: t.password,
                        prefixIcon: const Icon(Iconsax.password_check),
                        suffixIcon: IconButton(
                          onPressed: () => controller.hideNewPassword.toggle(),
                          icon: Icon(controller.hideNewPassword.value ? Iconsax.eye_slash : Iconsax.eye),
                        ),
                      ),
                    )),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Confirm Password
                    Obx(() => TextFormField(
                      controller: controller.confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please confirm your password';
                        if (value != controller.newPasswordController.text) return 'Passwords do not match';
                        return null;
                      },
                      obscureText: controller.hideConfirmPassword.value,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Iconsax.password_check),
                        suffixIcon: IconButton(
                          onPressed: () => controller.hideConfirmPassword.toggle(),
                          icon: Icon(controller.hideConfirmPassword.value ? Iconsax.eye_slash : Iconsax.eye),
                        ),
                      ),
                    )),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    // Submit Button
                    Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.updatePassword,
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                              )
                            : Text(t.submit),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
