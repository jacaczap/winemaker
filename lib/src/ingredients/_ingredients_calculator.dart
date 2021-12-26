import 'package:winemaker/src/common_models/alcohol.dart';
import 'package:winemaker/src/common_models/litres.dart';
import 'package:winemaker/src/common_models/sugar.dart';
import 'package:winemaker/src/constants/constants.dart';
import 'package:winemaker/src/desired_wine/desired_wine.dart';
import 'package:winemaker/src/ingredients/ingredients.dart';
import 'package:winemaker/src/must/must_measurements.dart';

Ingredients calculateIngredients(DesiredWine desiredWine, MustMeasurements must) {
  var expectedVolume = _calculateExpectedVolume(must.volume);

  var sugarToAdd = _calculateRequiredSugar(desiredWine, must, expectedVolume);

  var shouldAddYeast = true;
  var shouldAddNutrients = true;
  return Ingredients(sugarToAdd, expectedVolume, shouldAddYeast, shouldAddNutrients);
}

Litres _calculateExpectedVolume(Litres mustVolume) => mustVolume * (1 + averageRedGrapesJuiceDilution);

Kilograms _calculateRequiredSugar(DesiredWine desiredWine, MustMeasurements must, Litres expectedVolume) {
  var sugarForAlcohol = _calculateSugarForAlcohol(desiredWine.alcohol);
  var remainingSugarForAlcohol = sugarForAlcohol - must.sugar.toGramsPerLiter();
  return const Kilograms(15.0);
}

_GramsPerLiter _calculateSugarForAlcohol(Alcohol desiredAlcohol) {
  var sugarForAlcoholWithoutDilution = _GramsPerLiter(desiredAlcohol.value * 10 * 1.7);
  var sugarForAlcoholIncludingDilution = sugarForAlcoholWithoutDilution * (1 + averageRedGrapesJuiceDilution);
  return sugarForAlcoholIncludingDilution;
}

extension _BlgExtension on Blg {
  _GramsPerLiter toGramsPerLiter() => _GramsPerLiter(value * 10);
}

class _GramsPerLiter {
  final double value;

  _GramsPerLiter(this.value);

  _GramsPerLiter operator +(_GramsPerLiter other) => _GramsPerLiter(other.value + value);
  _GramsPerLiter operator -(_GramsPerLiter other) => _GramsPerLiter(other.value - value);
  _GramsPerLiter operator *(double other) => _GramsPerLiter(value * value);
}
