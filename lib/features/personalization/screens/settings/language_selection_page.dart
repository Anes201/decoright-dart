// screens/language_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:decoright/features/personalization/screens/settings/widgets/selection_screen.dart';

import '../../controllers/settings_controller.dart';


class LanguageSelectionScreen extends StatelessWidget {
  final SettingsController controller = Get.find();

  LanguageSelectionScreen({Key? key}) : super(key: key);

  final List<SelectionOption<String>> languages = [
    SelectionOption("en", "English"),
    SelectionOption("fr", "Français"),
    SelectionOption("ar", "العربية"),
  ];

  @override
  Widget build(BuildContext context) {
    return SelectionScreen<String>(
      title: "chooseLanguage".tr,
      selectedValue: controller.selectedLanguage,
      options: languages,
      onSelected: (langCode) {
        controller.changeLanguage(langCode);
      },
    );
  }
}