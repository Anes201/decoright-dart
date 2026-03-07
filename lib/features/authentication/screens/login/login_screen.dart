import 'package:decoright/features/authentication/screens/login/widgets/login_form.dart';
import 'package:decoright/features/authentication/screens/login/widgets/login_header.dart';
import 'package:decoright/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/socail_buttons.dart';
import '../../../../utils/constants/colors.dart';
import '../signup/signup.dart';
import '../../../../l10n/app_localizations.dart';

import 'package:decoright/features/authentication/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// logo, title and subtitle
              const TLoginHeader(),

              /// Form
              const TLoginForm(),

              /// Divider
              TFormDivider(dividerText: t.orSignInWith),
              const SizedBox(height: TSizes.spaceBtwSections,),

              /// footer
              const TSocialButtons(),
              
              const SizedBox(height: TSizes.spaceBtwSections),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(t.dontHaveAccount + " "),
                  TextButton(
                    onPressed: () => Get.to(() => const SignUpScreen()),
                    child: Text(
                      t.signUp,
                      style: const TextStyle(
                        color: TColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Get.find<AuthController>().loginAsGuest(),
                  icon: const Icon(Iconsax.user),
                  label: Text(t.continueAsGuest),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: TColors.primary),
                    foregroundColor: TColors.primary,
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