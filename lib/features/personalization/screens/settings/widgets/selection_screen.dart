// screens/selection_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/appbar/appbar.dart';

class SelectionScreen<T> extends StatelessWidget {
  final String title;
  final Rx<T> selectedValue;
  final List<SelectionOption<T>> options;
  final Function(T) onSelected;

  const SelectionScreen({
    Key? key,
    required this.title,
    required this.selectedValue,
    required this.options,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(showBackArrow: true, title: Text(title), centerTitle: true, elevation: 0),
      body: // Replace the ListView.builder body with this for super clean look:
      ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = selectedValue.value == option.value;

          return RadioListTile<T>(
            value: option.value,
            groupValue: selectedValue.value,
            onChanged: (value) {
              if (value != null) {
                onSelected(value);
                Get.back();
              }
            },
            title: Text(
              option.label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 17,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            tileColor: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : null,
            selected: isSelected,
            activeColor: Theme.of(context).colorScheme.primary,
          );
        },
      ),
    );
  }
}

class SelectionOption<T> {
  final T value;
  final String label;

  SelectionOption(this.value, this.label);
}
