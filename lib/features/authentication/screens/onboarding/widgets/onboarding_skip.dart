import 'package:decoright/features/authentication/screens/login/login_screen.dart';
import 'package:get/get.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
  super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Positioned(
      top: TDeviceUtils.getAppBarHeight(),
      right: TSizes.defaultSpace,
      child: TextButton(
        onPressed: () => Get.offAll(() => const LoginScreen()),
        child: Text(
          'Skip',
          style: TextStyle(color: TColors.primary),
        ),
      ),
    );
  }
}