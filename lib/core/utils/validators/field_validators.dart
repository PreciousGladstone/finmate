/// Centralized validation helpers for all form fields
class FieldValidators {
  /// Validates that a field is not empty
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? '$fieldName is required' : 'This field is required';
    }
    return null;
  }

  /// Validates email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailPattern).hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Validates that a value is a number
  static String? number(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? '$fieldName is required' : 'This field is required';
    }
    try {
      double.parse(value);
      return null;
    } catch (e) {
      return fieldName != null
          ? '$fieldName must be a valid number'
          : 'Please enter a valid number';
    }
  }

  /// Validates that a number is greater than zero
  static String? positiveNumber(String? value, {String? fieldName}) {
    final numberValidation = number(value, fieldName: fieldName);
    if (numberValidation != null) {
      return numberValidation;
    }
    try {
      final num = double.parse(value!);
      if (num <= 0) {
        return fieldName != null ? '$fieldName must be greater than 0' : 'Must be greater than 0';
      }
    } catch (e) {
      return 'Invalid number';
    }
    return null;
  }

  /// Validates minimum length
  static String? minLength(String? value, int minLen, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? '$fieldName is required' : 'This field is required';
    }
    if (value.length < minLen) {
      return fieldName != null
          ? '$fieldName must be at least $minLen characters'
          : 'Must be at least $minLen characters';
    }
    return null;
  }

  /// Validates maximum length
  static String? maxLength(String? value, int maxLen, {String? fieldName}) {
    if (value != null && value.length > maxLen) {
      return fieldName != null
          ? '$fieldName cannot exceed $maxLen characters'
          : 'Cannot exceed $maxLen characters';
    }
    return null;
  }

  /// Validates range (min and max length)
  static String? lengthRange(String? value, int minLen, int maxLen, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? '$fieldName is required' : 'This field is required';
    }
    if (value.length < minLen) {
      return fieldName != null
          ? '$fieldName must be at least $minLen characters'
          : 'Must be at least $minLen characters';
    }
    if (value.length > maxLen) {
      return fieldName != null
          ? '$fieldName cannot exceed $maxLen characters'
          : 'Cannot exceed $maxLen characters';
    }
    return null;
  }

  /// Validates that a number is within a specific range
  static String? numberRange(String? value, double min, double max, {String? fieldName}) {
    final numberValidation = number(value, fieldName: fieldName);
    if (numberValidation != null) {
      return numberValidation;
    }
    try {
      final num = double.parse(value!);
      if (num < min || num > max) {
        return fieldName != null
            ? '$fieldName must be between $min and $max'
            : 'Value must be between $min and $max';
      }
    } catch (e) {
      return 'Invalid number';
    }
    return null;
  }

  /// Combines multiple validators (returns first error)
  static String? compose(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  /// Validates URL format
  static String? url(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? '$fieldName is required' : 'This field is required';
    }
    try {
      Uri.parse(value);
      if (value.startsWith('http://') || value.startsWith('https://')) {
        return null;
      }
      return 'Please enter a valid URL';
    } catch (e) {
      return 'Please enter a valid URL';
    }
  }

  /// Validates phone number (basic validation)
  static String? phone(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? '$fieldName is required' : 'This field is required';
    }
    final phonePattern = r'^[0-9]{10,}$';
    if (!RegExp(phonePattern).hasMatch(value.replaceAll(RegExp(r'[^\d]'), ''))) {
      return fieldName != null ? '$fieldName must be a valid phone number' : 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validates password strength
  static String? password(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? '$fieldName is required' : 'This field is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  /// Validates that two fields match (e.g., password confirmation)
  static String? Function(String?) matchField(String fieldValue, {String? fieldName}) {
    return (String? confirmValue) {
      if (confirmValue == null || confirmValue.isEmpty) {
        return fieldName != null ? 'Confirm $fieldName is required' : 'This field is required';
      }
      if (confirmValue != fieldValue) {
        return fieldName != null ? '$fieldName do not match' : 'Fields do not match';
      }
      return null;
    };
  }
}
