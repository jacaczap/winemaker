double parseDoubleInput(String value) {
  return double.parse(value.replaceFirst(',', '.'));
}

/// Parses user input, treating empty input as `0`.
double parseDoubleInputOrZero(String? value) {
  if (value == null || value.isEmpty) return 0;
  return parseDoubleInput(value);
}

String? numberValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter value';
  }
  return _numericChecks(value);
}

/// Like [numberValidator] but allows empty input (treated as `0` on save).
String? optionalNumberValidator(String? value) {
  if (value == null || value.isEmpty) return null;
  return _numericChecks(value);
}

String? _numericChecks(String value) {
  final parsed = double.tryParse(value.replaceFirst(',', '.'));
  if (parsed == null) {
    return 'Value must be a number';
  }
  if (parsed < 0) {
    return 'Value cannot be negative';
  }
  return null;
}
