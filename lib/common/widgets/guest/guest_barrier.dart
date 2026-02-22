import 'package:decoright/features/authentication/controllers/auth_controller.dart';
import 'package:decoright/features/authentication/screens/login/login_screen.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:decoright/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class GuestBarrier extends StatelessWidget {
  final String title;
  final String message;

  const GuestBarrier({
    super.key,
    this.title = 'Login Required',
    this.message = 'You must be logged in to access this feature.',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.lock, size: 100, color: Colors.grey),
              const SizedBox(height: TSizes.spaceBtwSameSections),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.find<AuthController>().signOut(); // Clear guest state
                    Get.offAll(() => const LoginScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    side: BorderSide.none,
                  ),
                  child: const Text('Log In / Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
