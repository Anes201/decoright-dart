import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/services.dart';
import '../../../../utils/formatters/dz_phone_formatter.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/auth_controller.dart';

class ProfileCompletionScreen extends StatelessWidget {
  const ProfileCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => controller.signOut(),
            child: const Text("Sign Out"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Text(
                "Complete Your Profile",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              
              /// Explanation
              const Text(
                "We need this information to contact you about your design requests.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// First Name
              TextFormField(
                controller: controller.firstNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.user),
                  labelText: "First Name",
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              /// Last Name
              TextFormField(
                controller: controller.lastNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.user),
                  labelText: "Last Name",
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              /// Phone Number
              TextFormField(
                controller: controller.phoneNumberController,
                inputFormatters: [DzPhoneNumberFormatter()],
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.call),
                  labelText: "Phone Number",
                  hintText: "+213 5XX XX XX XX",
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Continue Button
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : () => controller.completeProfile(),
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
