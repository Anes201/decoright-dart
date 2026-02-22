import 'package:decoright/features/authentication/screens/login/login_screen.dart';
import 'package:decoright/utils/constants/image_strings.dart';
import 'package:decoright/utils/constants/sizes.dart';
import 'package:decoright/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/success_screen/success_acreen.dart';
import '../../../../l10n/app_localizations.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => const LoginScreen()),
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
                t.confirmEmail,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// example email (can be dynamic later)
              Text(
                'ycn585@gmail.com',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              Text(
                t.confirmEmailSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(
                          () => SuccessScreen(
                        image: TImages.staticSuccessIllustration,
                        title: t.yourAccountCreatedTitle,
                        subtitle: t.yourAccountCreatedSubtitle,
                        onPressed: () =>
                            Get.offAll(() => const LoginScreen()),
                      ),
                    );
                  },
                  child: Text(t.continueButton),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    // resend email logic
                  },
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
