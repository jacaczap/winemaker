import 'package:winemaker/l10n/app_localizations.dart';

double parseDoubleInput(String value) {
  return double.parse(value.replaceFirst(',', '.'));
}

/// Parses user input, treating empty input as `0`.
double parseDoubleInputOrZero(String? value) {
  if (value == null || value.isEmpty) return 0;
  return parseDoubleInput(value);
}

/// Builds a validator requiring a non-negative number, with localized messages.
String? Function(String?) numberValidator(AppLocalizations l10n) => (value) {
      if (value == null || value.isEmpty) {
        return l10n.validationRequired;
      }
      return _numericChecks(value, l10n);
    };

/// Like [numberValidator] but allows empty input (treated as `0` on save).
String? Function(String?) optionalNumberValidator(AppLocalizations l10n) =>
    (value) {
      if (value == null || value.isEmpty) return null;
      return _numericChecks(value, l10n);
    };

String? _numericChecks(String value, AppLocalizations l10n) {
  final parsed = double.tryParse(value.replaceFirst(',', '.'));
  if (parsed == null) {
    return l10n.validationNotANumber;
  }
  if (parsed < 0) {
    return l10n.validationNegative;
  }
  return null;
}
