import 'package:decoright/features/authentication/controllers/auth_controller.dart';
import 'package:decoright/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:decoright/features/authentication/screens/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../utils/constants/sizes.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final controller = Get.find<AuthController>();

    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            /// email
            TextFormField(
              controller: controller.emailController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.direct_right),
                labelText: t.email,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// password
            Obx(
              () => TextFormField(
                controller: controller.passwordController,
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.password_check),
                  labelText: t.password,
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                  ),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            /// remember me & forget password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// remember me
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: controller.rememberMe.value,
                        onChanged: (value) =>
                            controller.rememberMe.value = value!,
                      ),
                    ),
                    Text(
                      t.rememberMe,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),

                /// forget password
                TextButton(
                  onPressed: () => Get.to(() => const ForgetPassword()),
                  child: Text(t.forgetPassword),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// buttons
            Column(
              children: [
                /// sign in
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: controller.isLoading.value ? null : () => controller.signIn(),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(t.signIn),
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                /// login with otp (Alternative)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: controller.isLoading.value ? null : () => controller.loginWithOtp(),
                    child: Text(t.loginWithOtp),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                /// create account
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Get.to(() => const SignUpScreen()),
                    child: Text(t.signUp),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
