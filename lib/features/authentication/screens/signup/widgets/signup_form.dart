import 'package:decoright/features/authentication/controllers/auth_controller.dart';
import 'package:decoright/features/authentication/screens/signup/widgets/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import '../../../../../utils/formatters/dz_phone_formatter.dart';
import '../../../../../utils/constants/sizes.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final controller = Get.find<AuthController>();

    return Form(
      child: Column(
        children: [
          /// first and last name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstNameController,
                  decoration: InputDecoration(
                    labelText: t.firstName,
                    prefixIcon: const Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: controller.lastNameController,
                  decoration: InputDecoration(
                    labelText: t.lastName,
                    prefixIcon: const Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// email
          TextFormField(
            controller: controller.emailController,
            decoration: InputDecoration(
              labelText: t.email,
              prefixIcon: const Icon(Iconsax.direct),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// phone number
          TextFormField(
            controller: controller.phoneNumberController,
            inputFormatters: [DzPhoneNumberFormatter()],
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Iconsax.call),
              hintText: '+213 5XX XX XX XX',
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// password
          Obx(
            () => TextFormField(
              controller: controller.passwordController,
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: t.password,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                  icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                ),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// terms and conditions checkbox
          const TermsAndConditions(),

          /// signup button
          const SizedBox(height: TSizes.spaceBtwSections),
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value ? null : () => controller.signUp(),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(t.signUp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
