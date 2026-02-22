class TValidator {
  /// Validates an email address.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  /// Validates a password with at least:
  /// - 6 characters
  /// - 1 uppercase letter
  /// - 1 number
  /// - 1 special character
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    if (value.length < 6) return 'Password must be at least 6 characters long.';
    if (!value.contains(RegExp(r'[A-Z]'))) return 'Must contain at least one uppercase letter.';
    if (!value.contains(RegExp(r'[0-9]'))) return 'Must contain at least one number.';
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return 'Must contain at least one special character.';

    return null;
  }

  /// Validates a phone number (10-digit format).
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    final phoneRegExp = RegExp(r'^\d{10}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (10 digits required).';
    }

    return null;
  }

  /// Validates a username (alphanumeric, 3-15 characters).
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required.';
    }

    final usernameRegExp = RegExp(r'^[a-zA-Z0-9_]{3,15}$');
    if (!usernameRegExp.hasMatch(value)) {
      return 'Username must be 3-15 characters and contain only letters, numbers, and underscores.';
    }

    return null;
  }

  /// Validates a full name (only letters and spaces, min 3 chars).
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required.';
    }

    final nameRegExp = RegExp(r'^[a-zA-Z\s]{3,}$');
    if (!nameRegExp.hasMatch(value)) {
      return 'Invalid name (only letters and spaces, at least 3 characters).';
    }

    return null;
  }

  /// Validates if input is a number (integer or decimal).
  static String? validateNumeric(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required.';
    }

    final numericRegExp = RegExp(r'^[0-9]+(\.[0-9]+)?$');
    if (!numericRegExp.hasMatch(value)) {
      return 'Enter a valid number.';
    }

    return null;
  }

  /// Validates a URL.
  static String? validateURL(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required.';
    }

    final urlRegExp = RegExp(r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$');
    if (!urlRegExp.hasMatch(value)) {
      return 'Enter a valid URL.';
    }

    return null;
  }

  /// Validates a date in yyyy-mm-dd format.
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required.';
    }

    final dateRegExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegExp.hasMatch(value)) {
      return 'Enter a valid date in yyyy-mm-dd format.';
    }

    return null;
  }

  /// Validates a credit card number (basic check for 13-19 digits).
  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit card number is required.';
    }

    final creditCardRegExp = RegExp(r'^\d{13,19}$');
    if (!creditCardRegExp.hasMatch(value)) {
      return 'Invalid credit card number.';
    }

    return null;
  }

  /// Validates if a required field is not empty.
  static String? validateRequired(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }

    return null;
  }
}
