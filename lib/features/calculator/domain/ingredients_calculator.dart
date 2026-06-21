import 'package:winemaker/core/models/alcohol.dart';
import 'package:winemaker/core/models/litres.dart';
import 'package:winemaker/core/models/sugar.dart';
import 'package:winemaker/core/utils/math_utils.dart';
import 'package:winemaker/features/calculator/domain/calculation_constants.dart';
import 'package:winemaker/features/calculator/domain/desired_wine.dart';
import 'package:winemaker/features/calculator/domain/ingredients.dart';
import 'package:winemaker/features/calculator/domain/must_measurements.dart';

Ingredients calculateIngredients(DesiredWine desiredWine, MustMeasurements must) {
  var dilutionPerLiter = _dilutionPerLiter(must.acidity, desiredWine.acidity);

  var sugarToAddPerLiter = _calculateRequiredSugar(desiredWine, must, dilutionPerLiter);

  var volumeOfSugarThatWillBeAddedPerLiter = Litres(sugarToAddPerLiter.value * 0.6 / 1000);
  var waterToAddPerLiter = dilutionPerLiter - volumeOfSugarThatWillBeAddedPerLiter;

  var waterToAdd = waterToAddPerLiter * must.volume.value;
  var sugarToAdd = sugarToAddPerLiter.toKilograms(must.volume);
  var shouldAddYeast = true;
  var shouldAddNutrients = true;
  return Ingredients(sugarToAdd.roundTo(2), waterToAdd.roundTo(2), shouldAddYeast, shouldAddNutrients);
}

/// Extra litres of liquid to add per litre of juice so the must reaches the
/// desired acidity: `(measured / desired) - 1`. Clamped at 0 because juice can
/// only be diluted, never concentrated, by adding water.
Litres _dilutionPerLiter(GramsPerLiter measuredAcidity, GramsPerLiter desiredAcidity) {
  if (desiredAcidity.value <= 0) return const Litres(0);
  var ratio = (measuredAcidity.value / desiredAcidity.value) - 1;
  return Litres((ratio < 0 ? 0.0 : ratio).roundTo(2));
}

GramsPerLiter _calculateRequiredSugar(DesiredWine desiredWine, MustMeasurements must, Litres dilutionPerLiter) {
  var sugarForAlcohol = _calculateSugarForAlcohol(desiredWine.alcohol, dilutionPerLiter);
  var mustBlgWithoutNonSugarSubstances = must.sugar - averageRedGrapesNonSugarSubstances;
  var remainingSugarForAlcohol = sugarForAlcohol - mustBlgWithoutNonSugarSubstances.toGramsPerLiter();
  var sugarForSweetness = _sugarIncludingDilution(desiredWine.sugar, dilutionPerLiter);
  return remainingSugarForAlcohol + sugarForSweetness;
}

GramsPerLiter _calculateSugarForAlcohol(Alcohol desiredAlcohol, Litres dilutionPerLiter) {
  var sugarForAlcoholWithoutDilution = GramsPerLiter(desiredAlcohol.value * 10 * 1.7);
  var sugarForAlcoholIncludingDilution = _sugarIncludingDilution(sugarForAlcoholWithoutDilution, dilutionPerLiter);
  return sugarForAlcoholIncludingDilution;
}

GramsPerLiter _sugarIncludingDilution(GramsPerLiter sugarWithoutDilution, Litres dilutionPerLiter) =>
    sugarWithoutDilution * (1 + dilutionPerLiter.value);

extension _BlgExtension on Blg {
  GramsPerLiter toGramsPerLiter() => GramsPerLiter(value * 10);
}
