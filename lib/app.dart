import 'package:decoright/features/personalization/controllers/profile_controller.dart';
import 'package:decoright/features/authentication/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:decoright/utils/theme/theme.dart';
import 'package:decoright/features/authentication/controllers/auth_controller.dart';
import 'package:decoright/features/personalization/controllers/settings_controller.dart';
import 'package:decoright/l10n/app_localizations.dart'; // ← ADD THIS

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.put(SettingsController());
    Get.put(ProfileController(), permanent: true);
    Get.put(AuthController(), permanent: true);

    return Obx(() {
      final languageCode = settingsController.selectedLanguage.value;
      final locale = Locale(languageCode);

      return GetMaterialApp(
        debugShowCheckedModeBanner: false,

        themeMode: settingsController.selectedThemeMode.value,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,

        locale: locale,
        fallbackLocale: const Locale("en"),

        // FIXED: Use AppLocalizations instead of S.delegate
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,

        // Perfect RTL handling for Arabic
        builder: (context, child) {
          return Directionality(
            textDirection: languageCode == "ar" ? TextDirection.rtl : TextDirection.ltr,
            child: child!,
          );
        },

        home: const Scaffold(
          backgroundColor: TColors.primary,
          body: Center(
            child: OnBoardingScreen(),
          ),
        ),
      );
    });
  }
}