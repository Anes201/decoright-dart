import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../constants/colors.dart';
import '../helpers/helper_functions.dart';

class TLoaders {
  static BuildContext? get _context => Get.context;

  static void hideSnackBar() {
    if (_context != null) {
      ScaffoldMessenger.of(_context!).hideCurrentSnackBar();
    }
  }

  static void customToast({required String message}) {
    if (_context == null) return;

    ScaffoldMessenger.of(_context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(milliseconds: 1800),
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        content: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: THelperFunctions.isDarkMode(_context!)
                ? TColors.darkGrey.withValues(alpha: 0.95)
                : TColors.grey.withValues(alpha: 0.95),
          ),
          child: Center(
            child: Text(
              message,
              style: Theme.of(_context!)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  static void successSnackBar({
    required String title,
    String message = '',
    int duration = 3,
  }) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Iconsax.check, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: TColors.primary,
      colorText: Colors.white,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(16),
    );
  }

  static void warningSnackBar({
    required String title,
    String message = '',
    int duration = 3,
  }) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Iconsax.warning_2, color: Colors.black),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.yellow.shade700,
      colorText: Colors.black,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(16),
    );
  }

  static void errorSnackBar({
    required String title,
    String message = '',
    int duration = 3,
  }) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Iconsax.warning_2, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(16),
    );
  }
}
