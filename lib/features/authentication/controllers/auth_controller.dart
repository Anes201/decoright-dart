import 'package:decoright/utils/logging/logger.dart'; // Ensure we use project logger
import 'package:decoright/data/services/auth_service.dart';
import 'package:decoright/features/authentication/screens/signup/verify_email_screen.dart';
import 'package:decoright/features/authentication/screens/entry/profile_completion_screen.dart';
import 'package:decoright/features/authentication/screens/entry/welcome_screen.dart';
import 'package:decoright/features/authentication/screens/onboarding/onboarding_screen.dart';
import 'package:decoright/features/authentication/screens/password_configuration/new_password_screen.dart';
import 'package:decoright/navigation_menu.dart';
import 'package:decoright/utils/local_storage/storage_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final AuthService _authService = AuthService();

  // Form Keys
  final emailEntryFormKey = GlobalKey<FormState>();

  @override
  void onReady() {
    super.onReady();
    
    // Listen for auth state changes globally (helpful for Password Recovery/Deep links)
    _authService.authStateChanges.listen((AuthState state) {
      TLoggerHelper.debug("Auth state change: ${state.event}");
      if (state.event == AuthChangeEvent.passwordRecovery) {
        TLoggerHelper.info("Password recovery triggered, navigating to NewPasswordScreen");
        Get.to(() => const NewPasswordScreen());
      }
    });

    screenRedirect();
  }

  /// Initial Screen Redirect
  void screenRedirect() async {
    final user = _authService.getCurrentUser();
    final bool wasGuest = TLocalStorage.instance.readData('isGuest') ?? false;
    
    TLoggerHelper.debug("--- screenRedirect called ---");
    TLoggerHelper.debug("User: ${user?.email ?? 'NULL'}");
    TLoggerHelper.debug("Was Guest: $wasGuest");

    if (user != null) {
      TLoggerHelper.debug("User found, checking profile...");
      isGuest.value = false;
      await checkProfileAndNavigate();
    } else if (wasGuest) {
      TLoggerHelper.debug("Guest status persisted, redirecting to NavigationMenu");
      isGuest.value = true;
      Get.offAll(() => const NavigationMenu());
    } else {
      TLoggerHelper.debug("No user found and not guest, checking onboarding status...");
      
      // Load remembered email if exists
      final rememberedEmail = TLocalStorage.instance.readData('rememberedEmail');
      if (rememberedEmail != null && (rememberedEmail as String).isNotEmpty) {
        emailController.text = rememberedEmail;
        rememberMe.value = true;
      }

      final isFirstTime = TLocalStorage.instance.readData('isFirstTime');
      TLoggerHelper.debug("isFirstTime: $isFirstTime");
      
      if (isFirstTime == null || isFirstTime == true) {
        TLoggerHelper.debug("Redirecting to OnBoardingScreen");
        Get.offAll(() => const OnBoardingScreen());
      } else {
        TLoggerHelper.debug("Redirecting to WelcomeScreen");
        Get.offAll(() => const WelcomeScreen());
      }
    }
  }

  // Observable states
  final isLoading = false.obs;
  final hidePassword = true.obs;
  final isGuest = false.obs;
  final rememberMe = false.obs;

  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController(text: '+213 ');
  final otpController = TextEditingController();
  
  // Track OTP type (signup or magiclink)
  OtpType currentOtpType = OtpType.signup;

  /// Login as Guest
  void loginAsGuest() {
    isGuest.value = true;
    TLocalStorage.instance.saveData('isGuest', true);
    Get.offAll(() => const NavigationMenu());
  }

  /// Sign In
  Future<void> signIn() async {
    // Legacy password sign in - keep for now but we will use OTP mostly
    try {
      isLoading.value = true;
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        Get.snackbar(
          'Error',
          'Please fill in all fields',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
        return;
      }

      final response = await _authService.signIn(email: email, password: password);

      if (response.user != null) {
        isGuest.value = false;
        
        // Handle Remember Me
        if (rememberMe.value) {
          TLocalStorage.instance.saveData('rememberedEmail', email);
        } else {
           TLocalStorage.instance.removeData('rememberedEmail');
        }

        Get.snackbar(
          'Success',
          'Welcome back!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
        
        Get.offAll(() => const NavigationMenu());
      }
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString().replaceAll('Exception: ', '').replaceAll('AuthException:', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign In with OTP
  Future<void> loginWithOtp() async {
    try {
      isLoading.value = true;
      final email = emailController.text.trim();
      if (email.isEmpty || !GetUtils.isEmail(email)) {
        Get.snackbar(
          'Invalid Email',
          'Please enter a valid email address.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
        return;
      }

      await _authService.signInWithOtp(email: email);
      currentOtpType = OtpType.signup;
      
      // Handle Remember Me for OTP
      if (rememberMe.value) {
        TLocalStorage.instance.saveData('rememberedEmail', email);
      } else {
        TLocalStorage.instance.removeData('rememberedEmail');
      }

      Get.to(() => VerifyEmailScreen(email: email));
    } catch (e) {
      Get.snackbar(
        'OTP Failed',
        e.toString().replaceAll('Exception: ', '').replaceAll('AuthException:', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign In with Google
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      
      // Sign in with Google OAuth - this opens browser/webview
      final result = await _authService.signInWithGoogle();
      
      if (!result) {
        Get.snackbar(
          'Error',
          'Failed to initiate Google sign-in',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
        return;
      }
      
      // Listen for auth state change (OAuth callback)
      // The auth state will change when OAuth completes
      _authService.authStateChanges.listen((AuthState state) async {
        if (state.event == AuthChangeEvent.signedIn && state.session != null) {
          TLoggerHelper.debug('Google OAuth successful, checking profile...');
          isLoading.value = false;
          await checkProfileAndNavigate();
        }
      });
      
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Google Login Failed',
        e.toString().replaceAll('Exception: ', '').replaceAll('AuthException:', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Sign Up
  Future<void> signUp() async {
    try {
      isLoading.value = true;

      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final phoneNumber = phoneNumberController.text.trim();
      final fullName = '$firstName $lastName'.trim();

      final phoneDigits = phoneNumber.replaceAll(RegExp(r'\D'), '').replaceFirst('213', '');
      if (email.isEmpty || password.isEmpty || firstName.isEmpty || lastName.isEmpty || phoneNumber.isEmpty || phoneDigits.length != 9) {
        Get.snackbar(
          'Error',
          phoneDigits.length != 9 ? 'Please enter a valid Algerian phone number (9 digits).' : 'Please fill in all fields',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
        return;
      }

      final response = await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phone: phoneNumber,
      );

      if (response.user != null) {
        isGuest.value = false;
        currentOtpType = OtpType.signup;
        // Instead of snackbar and navigation to menu, go to verification screen
        Get.to(() => VerifyEmailScreen(email: email));
      }
    } catch (e) {
      String errorMessage = e.toString().replaceAll('Exception: ', '').replaceAll('AuthException:', '');
      
      // Handle duplicate phone number error from Supabase/PostgreSQL
      if (errorMessage.contains('23505') || errorMessage.toLowerCase().contains('duplicate') || errorMessage.toLowerCase().contains('unique constraint')) {
        errorMessage = 'This phone number is already registered. Please use a different one or log in.';
      }

      Get.snackbar(
        'Sign Up Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify Email OTP
  Future<void> verifyEmailOTP(String email) async {
    try {
      isLoading.value = true;
      final token = otpController.text.trim();

      if (token.isEmpty || token.length != 6) {
        Get.snackbar(
          'Error', 
          'Please enter a valid 6-digit code', 
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
        return;
      }

      try {
        // Try the current expected type first
        await _authService.verifyOTP(email: email, token: token, type: currentOtpType);
      } catch (e) {
        // If it fails, and we used signup, try magiclink (for existing users)
        if (currentOtpType == OtpType.signup) {
           TLoggerHelper.debug("Verification with signup failed, retrying with magiclink...");
           await _authService.verifyOTP(email: email, token: token, type: OtpType.magiclink);
        } 
        // If we used magiclink/email, try signup (in case it was actually a new signup)
        else if (currentOtpType == OtpType.magiclink || currentOtpType == OtpType.email) {
           TLoggerHelper.debug("Verification with magiclink failed, retrying with signup...");
           await _authService.verifyOTP(email: email, token: token, type: OtpType.signup);
        } else {
          rethrow;
        }
      }

      // Successfully verified. Now check if profile is complete.
      await checkProfileAndNavigate();
      
    } catch (e) {
      // Flow 2: Do NOT show technical errors
      Get.snackbar(
        'Verification Failed', 
        'The code you entered is invalid or has expired. Please try again.', 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Check if user has completed profile and navigate accordingly
  Future<void> checkProfileAndNavigate() async {
    final user = _authService.getCurrentUser();
    if (user == null) {
      Get.offAllNamed('/login'); // Or back to entry
      return;
    }

    final profile = await _authService.getUserProfile(user.id);
    
    // Check if mandatory fields are present
    final bool hasFullName = profile != null && profile['full_name'] != null && (profile['full_name'] as String).isNotEmpty;
    final bool hasPhone = profile != null && profile['phone'] != null && (profile['phone'] as String).isNotEmpty;

    if (!hasFullName || !hasPhone) {
      Get.offAll(() => const ProfileCompletionScreen());
    } else {
      isGuest.value = false;
      Get.offAll(() => const NavigationMenu());
    }
  }

  /// Mandatory Profile Completion
  Future<void> completeProfile() async {
    try {
      isLoading.value = true;
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final phoneNumber = phoneNumberController.text.trim();

      final phoneDigits = phoneNumber.replaceAll(RegExp(r'\D'), '').replaceFirst('213', '');
      if (firstName.isEmpty || lastName.isEmpty || phoneNumber.isEmpty || phoneDigits.length != 9) {
        Get.snackbar(
          'Error',
          phoneDigits.length != 9 ? 'Please enter a valid Algerian phone number (9 digits).' : 'Please fill in all fields to continue.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
        return;
      }

      await _authService.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phoneNumber,
      );

      Get.snackbar(
        'Success',
        'Profile completed! Welcome to DecoRight.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
      
      isGuest.value = false;
      Get.offAll(() => const NavigationMenu());
    } catch (e) {
      String errorMessage = e.toString().replaceAll('Exception: ', '').replaceAll('PostgrestException:', '');
      
      if (errorMessage.contains('23505') || errorMessage.toLowerCase().contains('duplicate') || errorMessage.toLowerCase().contains('unique constraint')) {
        errorMessage = 'This phone number is already in use. Please use a different one.';
      } else {
        // Log the error for debugging and show a more descriptive message if possible
        errorMessage = 'Failed to complete profile: $errorMessage';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Resend Email OTP
  Future<void> resendEmailOTP(String email) async {
    try {
      await _authService.resendEmailOTP(email: email, type: currentOtpType);
      Get.snackbar(
        'Success', 
        'Confirmation code resent to your email.', 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Failed to resend code: $e', 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      isGuest.value = false;
      TLocalStorage.instance.saveData('isGuest', false);
      
      Get.snackbar(
        'Success',
        'Logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );

      // Navigate back to Welcome/Entry
      Get.offAll(() => const WelcomeScreen());
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
