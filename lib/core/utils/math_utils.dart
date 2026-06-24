extension DoubleRoundExtension on double {
  double roundTo(int decimalPlaces) => double.parse(toStringAsFixed(decimalPlaces));
}
