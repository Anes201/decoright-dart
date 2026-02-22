import 'package:decoright/common/widgets/login_signup/form_divider.dart';
import 'package:decoright/common/widgets/login_signup/socail_buttons.dart';
import 'package:decoright/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:decoright/utils/constants/sizes.dart';
import 'package:decoright/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

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
              /// title
              Text(
                t.letsCreateYourAccount,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// form
              const SignUpForm(),
              const SizedBox(height: TSizes.spaceBtwSections),
              /// divider
              TFormDivider(dividerText: t.orSignUpWith),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// social buttons
              const TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

