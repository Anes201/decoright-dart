import 'package:decoright/data/services/auth_service.dart';
import 'package:decoright/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  final AuthService _authService = AuthService();

  // Observable states
  final isLoading = false.obs;

  // Text editing controllers
  final emailController = TextEditingController();

 /// Send password reset email
  Future<void> sendPasswordResetEmail() async {
    try {
      isLoading.value = true;

      final email = emailController.text.trim();

      if (email.isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter your email address',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
        return;
      }

      // Validate email format
      if (!GetUtils.isEmail(email)) {
        Get.snackbar(
          'Error',
          'Please enter a valid email address',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
        return;
      }

      await _authService.resetPassword(email: email);

      // Navigate to reset confirmation screen
      Get.off(() => const ResetPassword());

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send reset email: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
