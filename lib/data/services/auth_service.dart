import 'package:decoright/utils/logging/logger.dart';
import 'package:decoright/core/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Sign up a new user
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'phone': phone,
      },
    );
  }

  /// Sign in with OTP (sent to email)
  Future<void> signInWithOtp({required String email}) async {
    await _client.auth.signInWithOtp(
      email: email,
      shouldCreateUser: true, // Allow auto-signup
    );
  }

  /// Verify OTP (generic for signup and login)
  Future<AuthResponse> verifyOTP({
    required String email,
    required String token,
    required OtpType type,
  }) async {
    return await _client.auth.verifyOTP(
      email: email,
      token: token,
      type: type,
    );
  }

  /// Verify email OTP (Legacy wrapper for signup)
  Future<AuthResponse> verifyEmailOTP({required String email, required String token}) async {
    return await verifyOTP(email: email, token: token, type: OtpType.signup);
  }

  /// Resend email OTP
  Future<void> resendEmailOTP({
    required String email,
    OtpType type = OtpType.signup,
  }) async {
    await _client.auth.resend(
      type: type,
      email: email,
    );
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    return await _client.auth.signInWithOAuth(
      OAuthProvider.google,
    );
  }

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Send password reset email
  Future<void> resetPassword({required String email, String? redirectTo}) async {
    await _client.auth.resetPasswordForEmail(email, redirectTo: redirectTo);
  }

  /// Update password (after reset)
  Future<UserResponse> updatePassword({required String newPassword}) async {
    return await _client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }
  /// Get current user
  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  /// Get user profile from public.profiles table
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return response;
    } catch (e) {
      return null;
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        TLoggerHelper.error("updateProfile failed: userId is null");
        throw Exception('User session not found. Please log in again.');
      }

      TLoggerHelper.debug("Updating profile for user: $userId with phone: $phone");

      // We try update first because the trigger should have created the profile
      final response = await _client.from('profiles').update({
        'phone': phone,
        'full_name': '$firstName $lastName',
      }).eq('id', userId).select();

      // If no row was updated, it means the trigger didn't run or failed
      if (response.isEmpty) {
        TLoggerHelper.warning("Profile not found for $userId, attempting to insert instead.");
        await _client.from('profiles').insert({
          'id': userId,
          'phone': phone,
          'full_name': '$firstName $lastName',
          'role': 'customer',
        });
      }
      
      TLoggerHelper.info("Profile updated successfully for $userId");
    } catch (e) {
      TLoggerHelper.error("Error in updateProfile: $e");
      rethrow;
    }
  }

  /// Listen to auth state changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
