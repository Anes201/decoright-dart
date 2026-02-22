import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/auth_controller.dart';

class EmailEntryScreen extends StatelessWidget {
  const EmailEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Text(
                "Enter your Email",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              
              /// Helper Text
              const Text(
                "We’ll send you a 6-digit code to verify your email.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Email Input
              TextFormField(
                controller: controller.emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Continue Button
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : () => controller.loginWithOtp(),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text("Continue"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
