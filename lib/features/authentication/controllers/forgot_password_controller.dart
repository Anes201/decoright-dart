import 'package:decoright/data/services/auth_service.dart';
import 'package:decoright/features/authentication/screens/login/login_screen.dart';
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
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Form Keys
  final newPasswordFormKey = GlobalKey<FormState>();

  // Observables for visibility
  final hideNewPassword = true.obs;
  final hideConfirmPassword = true.obs;

 /// Send password reset email
  Future<void> sendPasswordResetEmail() async {
    try {
      isLoading.value = true;

      final email = emailController.text.trim();

      if (email.isEmpty || !GetUtils.isEmail(email)) {
        Get.snackbar(
          'Error',
          'Please enter a valid email address',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
        return;
      }

      // Supabase redirection URL using our custom scheme
      // Note: This URL must be allowed in Supabase Authentication > URL Configuration
      const redirectTo = 'decoright://reset-password';

      await _authService.resetPassword(email: email, redirectTo: redirectTo);

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

  /// Update password logic
  Future<void> updatePassword() async {
    try {
      isLoading.value = true;

      // Validate Form
      if (!newPasswordFormKey.currentState!.validate()) {
        return;
      }

      final newPassword = newPasswordController.text.trim();

      await _authService.updatePassword(newPassword: newPassword);

      Get.snackbar(
        'Success',
        'Your password has been reset successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );

      // Navigate to Login
      Get.offAll(() => const LoginScreen());

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update password: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
