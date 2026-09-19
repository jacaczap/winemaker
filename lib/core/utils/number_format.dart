/// Formats a measurement for display, dropping a trailing `.0`.
///
/// Amounts are stored as doubles, so a whole number would otherwise read
/// "5.0 l" in one place and "5 l" in another.
String formatAmount(double value) =>
    value == value.roundToDouble() ? value.toStringAsFixed(0) : '$value';
