import 'package:decoright/features/authentication/controllers/forgot_password_controller.dart';
import 'package:decoright/features/authentication/screens/login/login_screen.dart';
import 'package:decoright/utils/constants/image_strings.dart';
import 'package:decoright/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../utils/helpers/helper_functions.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final controller = ForgotPasswordController.instance;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Image(
                width: THelperFunctions.screenWidth() * 0.6,
                image: const AssetImage(
                  TImages.deliveredEmailIllustration,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              Text(
                t.changeYourPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              Text(
                t.changeYourPasswordSubTitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAll(() => const LoginScreen()),
                  child: Text(t.done),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => controller.sendPasswordResetEmail(),
                  child: Text(t.resendEmail),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
