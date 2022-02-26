import 'package:winemaker/src/common_models/litres.dart';
import 'package:winemaker/src/utils/math_utils.dart';

class Blg {
  final double value;

  const Blg(this.value);

  Blg operator +(Blg other) => Blg(value + other.value);

  Blg operator -(Blg other) => Blg(value - other.value);

  @override
  String toString() => value.toString();
}

class Kilograms {
  final double value;

  const Kilograms(this.value);

  Kilograms operator +(Kilograms other) => Kilograms(value + other.value);

  Kilograms operator -(Kilograms other) => Kilograms(value - other.value);

  @override
  String toString() => value.toString();

  Kilograms roundTo(int decimalPlaces) => Kilograms(value.roundTo(decimalPlaces));
}

class GramsPerLiter {
  final double value;

  const GramsPerLiter(this.value);

  GramsPerLiter operator +(GramsPerLiter other) => GramsPerLiter(value + other.value);

  GramsPerLiter operator -(GramsPerLiter other) => GramsPerLiter(value - other.value);

  GramsPerLiter operator *(double other) => GramsPerLiter(value * other);

  Kilograms toKilograms(Litres volume) => Kilograms(volume.value * value / 1000);

  @override
  String toString() => value.toString();
}
