import 'package:winemaker/src/utils/math_utils.dart';

class Litres {
  final double value;

  const Litres(this.value);

  Litres operator +(Litres other) => Litres(value + other.value);

  Litres operator -(Litres other) => Litres(value - other.value);

  Litres operator *(double other) => Litres(value * other);

  @override
  String toString() => value.toString();

  Litres roundTo(int decimalPlaces) => Litres(value.roundTo(decimalPlaces));
}
