// screens/theme_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';
import 'widgets/selection_screen.dart';

class ThemeSelectionScreen extends StatelessWidget {
  final SettingsController controller = Get.find();

  ThemeSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectionScreen<ThemeMode>(
      title: "Choose Theme",
      selectedValue: controller.selectedThemeMode,
      options: [
        SelectionOption(ThemeMode.system, "System Default"),
        SelectionOption(ThemeMode.light, "Light"),
        SelectionOption(ThemeMode.dark, "Dark"),
      ],
      onSelected: (themeMode) {
        controller.changeThemeMode(themeMode);
      },
    );
  }
}