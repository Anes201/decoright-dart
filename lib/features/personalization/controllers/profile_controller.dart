import 'package:decoright/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final AuthService _authService = AuthService();

  // Observable states
  final isLoading = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<Map<String, dynamic>?> userProfile = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  /// Load current user profile from Supabase
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;

      // Get current user
      final user = _authService.getCurrentUser();
      if (user == null) {
        // Silent return for guests
        isLoading.value = false;
        return;
      }

      currentUser.value = user;

      // Fetch user profile from database
      final profile = await _authService.getUserProfile(user.id);
      userProfile.value = profile;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get user's full name
  String get fullName => userProfile.value?['full_name'] ?? 'Guest User';

  /// Get user's email
  String get email => currentUser.value?.email ?? 'No email';

  /// Get user's role
  String get role => userProfile.value?['role'] ?? 'customer';

  /// Get user's phone
  String get phone => userProfile.value?['phone'] ?? 'No phone';

  /// Get account creation date  
  String get activeSince {
    final createdAt = currentUser.value?.createdAt;
    if (createdAt == null) return 'Unknown';

    final date = DateTime.parse(createdAt);
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return 'Active since - ${monthNames[date.month - 1]}, ${date.year}';
  }

  /// Split full name to first/last
  String get firstName => fullName.split(' ').first;
  String get lastName => fullName.split(' ').length > 1 
      ? fullName.split(' ').sublist(1).join(' ') 
      : '';

  /// Refresh profile data
  Future<void> refresh() async {
    await loadUserProfile();
  }
}
