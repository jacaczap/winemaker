import 'package:winemaker/src/common_models/alcohol.dart';
import 'package:winemaker/src/common_models/litres.dart';
import 'package:winemaker/src/common_models/sugar.dart';
import 'package:winemaker/src/constants/constants.dart';
import 'package:winemaker/src/desired_wine/desired_wine.dart';
import 'package:winemaker/src/ingredients/ingredients.dart';
import 'package:winemaker/src/must/must_measurements.dart';

Ingredients calculateIngredients(DesiredWine desiredWine, MustMeasurements must) {
  var sugarToAddPerLiter = _calculateRequiredSugar(desiredWine, must);

  var volumeOfSugarThatWillBeAddedPerLiter = Litres(sugarToAddPerLiter.value * 0.6 / 1000);
  var waterToAddPerLiter = averageRedGrapesJuiceDilutionPerLiter - volumeOfSugarThatWillBeAddedPerLiter;

  var waterToAdd = waterToAddPerLiter * must.volume.value;
  var sugarToAdd = sugarToAddPerLiter.toKilograms(must.volume);
  var shouldAddYeast = true;
  var shouldAddNutrients = true;
  return Ingredients(sugarToAdd.roundTo(2), waterToAdd.roundTo(2), shouldAddYeast, shouldAddNutrients);
}

GramsPerLiter _calculateRequiredSugar(DesiredWine desiredWine, MustMeasurements must) {
  var sugarForAlcohol = _calculateSugarForAlcohol(desiredWine.alcohol);
  var mustBlgWithoutNonSugarSubstances = must.sugar - averageRedGrapesNonSugarSubstances;
  var remainingSugarForAlcohol = sugarForAlcohol - mustBlgWithoutNonSugarSubstances.toGramsPerLiter();
  var sugarForSweetness = _sugarIncludingDilution(desiredWine.sugar, averageRedGrapesJuiceDilutionPerLiter);
  return remainingSugarForAlcohol + sugarForSweetness;
}

GramsPerLiter _calculateSugarForAlcohol(Alcohol desiredAlcohol) {
  var sugarForAlcoholWithoutDilution = GramsPerLiter(desiredAlcohol.value * 10 * 1.7);
  var sugarForAlcoholIncludingDilution = _sugarIncludingDilution(sugarForAlcoholWithoutDilution, averageRedGrapesJuiceDilutionPerLiter);
  return sugarForAlcoholIncludingDilution;
}

GramsPerLiter _sugarIncludingDilution(GramsPerLiter sugarWithoutDilution, Litres dilutionPerLiter) =>
    sugarWithoutDilution * (1 + dilutionPerLiter.value);

extension _BlgExtension on Blg {
  GramsPerLiter toGramsPerLiter() => GramsPerLiter(value * 10);
}
