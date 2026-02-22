import 'package:flutter/services.dart';

class DzPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // 1. Handle backspace on the space after +213
    if (oldValue.text == '+213 ' && newValue.text == '+213') {
       return newValue.copyWith(
        text: '+213 ',
        selection: const TextSelection.collapsed(offset: 5),
      );
    }

    // 2. Force +213 prefix
    if (!text.startsWith('+213 ')) {
      text = '+213 ';
    }

    // 3. Extract only digits after the prefix
    String prefix = '+213 ';
    String remaining = text.substring(prefix.length).replaceAll(RegExp(r'\D'), '');

    // 4. Limit to 9 digits (Algerian mobile format: 5/6/7XX XX XX XX)
    if (remaining.length > 9) {
      remaining = remaining.substring(0, 9);
    }

    // 5. Ensure first digit is 5, 6, or 7 (Mobile) or 2 (Fixed-line/ADSL)
    // Most users will be mobile. Fixed lines are 2, 3, 4 etc but let's stick to mobile mostly.
    // Actually, let's just allow digits but mention mobile.
    // If first digit is not 5, 6, 7 or 2, we could restrict it or just let it be.
    // The user said "Algerian code phones".

    // 6. Format: +213 540 12 34 56
    String formatted = prefix;
    for (int i = 0; i < remaining.length; i++) {
      formatted += remaining[i];
      // Spaces at indices 2, 4, 6 of the 'remaining' string
      if ((i == 2 || i == 4 || i == 6) && i != remaining.length - 1) {
        formatted += ' ';
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
