import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:decoright/utils/local_storage/storage_utility.dart';

class SettingsController extends GetxController {
  static const String _themeKey = "app_theme_mode";
  static const String _languageKey = "app_language";

  /// Reactive theme mode
  final selectedThemeMode = ThemeMode.system.obs;

  /// Reactive language code: "en" | "fr" | "ar"
  final selectedLanguage = "en".obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
    _loadLanguage();
  }

  // ======================== THEME ========================

  void _loadThemeMode() {
    final saved = TLocalStorage.instance.readData<String>(_themeKey);

    selectedThemeMode.value = saved == "light"
        ? ThemeMode.light
        : saved == "dark"
        ? ThemeMode.dark
        : ThemeMode.system;
  }

  void changeThemeMode(ThemeMode mode) {
    selectedThemeMode.value = mode;

    final value = mode == ThemeMode.light
        ? "light"
        : mode == ThemeMode.dark
        ? "dark"
        : "system";

    TLocalStorage.instance.saveData(_themeKey, value);
  }

  // Helper shortcuts
  void setLightTheme() => changeThemeMode(ThemeMode.light);
  void setDarkTheme() => changeThemeMode(ThemeMode.dark);
  void setSystemTheme() => changeThemeMode(ThemeMode.system);

  // ======================== LANGUAGE ========================

  void _loadLanguage() {
    final saved = TLocalStorage.instance.readData<String>(_languageKey);
    if (saved != null && ["en", "fr", "ar"].contains(saved)) {
      selectedLanguage.value = saved;
    }
  }

  /// Change language + persist + instantly update the app
  void changeLanguage(String langCode) {
    if (selectedLanguage.value == langCode) return;

    selectedLanguage.value = langCode;
    TLocalStorage.instance.saveData(_languageKey, langCode);

    // This single line updates the entire app locale (including RTL flip)
    Get.updateLocale(Locale(langCode));

    // Optional: force a full rebuild if something doesn't update immediately
    // Get.forceAppUpdate();
  }

  // Helper getters often used in UI
  bool get isArabic => selectedLanguage.value == "ar";
  bool get isDarkMode => selectedThemeMode.value == ThemeMode.dark;
}