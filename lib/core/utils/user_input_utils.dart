double parseDoubleInput(String value) {
  return double.parse(value.replaceFirst(',', '.'));
}

String? numberValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter value';
  }
  final parsed = double.tryParse(value.replaceFirst(',', '.'));
  if (parsed == null) {
    return 'Value must be a number';
  }
  if (parsed < 0) {
    return 'Value cannot be negative';
  }
  return null;
}
