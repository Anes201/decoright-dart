import 'package:decoright/features/authentication/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';


class TSocialButtons extends StatelessWidget {
  const TSocialButtons({
  super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: TColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () => Get.find<AuthController>().signInWithGoogle(),
            icon: const Image(
              width: TSizes.iconMd,
              height: TSizes.iconMd,
              image: AssetImage(
                TImages.google,
              ),
            ),
          ),
        ),
      ],
    );
  }
}