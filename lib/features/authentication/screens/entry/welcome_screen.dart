import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/auth_controller.dart';
import '../login/login_screen.dart';
import '../signup/signup.dart';
import 'email_entry_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final controller = Get.find<AuthController>();

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            /// Logo
            Image(
              height: 150,
              image: AssetImage(
                isDark ? TImages.darkAppLogo : TImages.lightAppLogo,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Tagline
            Text(
              "Design your space with DecoRight",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : TColors.dark,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),

            /// Email Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const EmailEntryScreen()),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: TSizes.buttonHeight),
                ),
                child: const Text("Continue with Email"),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Divider
            Row(
              children: [
                Flexible(
                  child: Divider(
                    color: isDark ? TColors.darkGrey : TColors.grey,
                    thickness: 0.5,
                    indent: 60,
                    endIndent: 5,
                  ),
                ),
                Text(
                  "Or",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Flexible(
                  child: Divider(
                    color: isDark ? TColors.darkGrey : TColors.grey,
                    thickness: 0.5,
                    indent: 5,
                    endIndent: 60,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Google Sign In Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => controller.signInWithGoogle(),
                icon: Image.asset(
                  TImages.google,
                  height: 24,
                  width: 24,
                ),
                label: const Text("Continue with Google"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: TSizes.buttonHeight),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Guest Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => controller.loginAsGuest(),
                child: const Text("Continue as Guest"),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Login & Sign Up Links
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                TextButton(
                  onPressed: () => Get.to(() => const LoginScreen()),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      color: TColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("New here? "),
                TextButton(
                  onPressed: () => Get.to(() => const SignUpScreen()),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(
                    "Create account",
                    style: TextStyle(
                      color: TColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
          ],
        ),
      ),
    );
  }
}
