import 'package:winemaker/core/models/alcohol.dart';
import 'package:winemaker/core/models/sugar.dart';
import 'package:winemaker/features/calculator/domain/calculation_constants.dart';
import 'package:winemaker/features/calculator/domain/desired_wine.dart';
import 'package:winemaker/features/calculator/domain/ingredients_calculator.dart';
import 'package:winemaker/features/calculator/domain/must_measurements.dart';

/// Bounds on the desired-wine targets implied by the measured must.
///
/// Outside these the recipe would need negative water or negative sugar, which
/// is another way of saying the wine cannot be made from this must.
class TargetLimits {
  const TargetLimits({required this.maxAcidity, required this.minAlcohol});

  final GramsPerLiter maxAcidity;
  final Alcohol minAlcohol;
}

TargetLimits targetLimits(MustMeasurements must, DesiredWine desiredWine) =>
    TargetLimits(
      maxAcidity: _maxAcidity(must, desiredWine),
      minAlcohol: _minAlcohol(must, desiredWine),
    );

/// The most acidic wine still reachable from [must].
///
/// The sugar needed for the target occupies volume, so it dilutes the must
/// whether the winemaker wants it or not. Asking for a more acidic wine than
/// this would mean evaporating water, and is what made the calculator return
/// negative water.
GramsPerLiter _maxAcidity(MustMeasurements must, DesiredWine desiredWine) {
  final forced = _forcedDilutionPerLiter(must, desiredWine);
  return GramsPerLiter(must.acidity.value / (1 + forced));
}

/// The weakest wine still reachable from [must].
///
/// Below this the must already carries more sugar than the target needs, which
/// is what made the calculator return negative sugar. The sweetness competes
/// for the same sugar, so it is part of the bound.
Alcohol _minAlcohol(MustMeasurements must, DesiredWine desiredWine) {
  final dilution = dilutionPerLiter(must.acidity, desiredWine.acidity);
  final sugarLeftForAlcohol =
      _naturalSugarPerLiter(must).value / (1 + dilution.value) -
          desiredWine.sugar.value;
  if (sugarLeftForAlcohol <= 0) return const Alcohol(0);
  return Alcohol(sugarLeftForAlcohol / sugarPerAlcoholPercent);
}

/// Smallest dilution that keeps the water non-negative.
///
/// Solving `dilution >= sugarVolume` for the dilution, where the sugar itself
/// grows with the dilution, gives `c(K - N) / (1 - cK)`: `c` litres per gram of
/// sugar, `K` the sugar the target asks for undiluted, `N` the sugar the must
/// already has.
double _forcedDilutionPerLiter(MustMeasurements must, DesiredWine desiredWine) {
  final targetSugar = desiredWine.alcohol.value * sugarPerAlcoholPercent +
      desiredWine.sugar.value;
  final mustSugar = _naturalSugarPerLiter(must).value;
  final scaled = litresPerGramOfSugar * targetSugar;
  final forced =
      litresPerGramOfSugar * (targetSugar - mustSugar) / (1 - scaled);
  return forced < 0 ? 0 : forced;
}

GramsPerLiter _naturalSugarPerLiter(MustMeasurements must) =>
    (must.sugar - averageRedGrapesNonSugarSubstances).toGramsPerLiter();
