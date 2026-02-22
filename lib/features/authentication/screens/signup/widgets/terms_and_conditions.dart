import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final t = AppLocalizations.of(context)!;

    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: true,
            onChanged: (value) {},
          ),
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${t.iAgreeTo} ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: '${t.privacyPolicy} ',
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: isDark ? TColors.white : TColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor:
                    isDark ? TColors.white : TColors.primary,
                  ),
                ),
                TextSpan(
                  text: '${t.and} ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: t.termsAndConditions,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: isDark ? TColors.white : TColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor:
                    isDark ? TColors.white : TColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}