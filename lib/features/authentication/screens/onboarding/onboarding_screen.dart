import 'package:decoright/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:decoright/features/authentication/screens/onboarding/widgets/onboard_next_button.dart';
import 'package:decoright/features/authentication/screens/onboarding/widgets/onboarding_navigator.dart';
import 'package:decoright/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:decoright/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:decoright/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../l10n/app_localizations.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          /// Horizontal Scrollable pages
          PageView(
            controller: controller.pagecontroller,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnBoardingPage(
                title: t.onboarding1title,
                subtitle: t.onboarding1,
                name: TImages.onBoardingImage1,
              ),
              OnBoardingPage(
                title: t.onboarding2title,
                subtitle: t.onboarding2,
                name: TImages.onBoardingImage2,
              ),
              OnBoardingPage(
                title: t.onboarding3title,
                subtitle: t.onboarding3,
                name: TImages.onBoardingImage3,
              ),
            ],
          ),

          /// Skip Button
          const OnBoardingSkip(),

          /// Dot Navigation SmoothPageIndicator
          const OnBoardNavigation(),

          /// circular button
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}
