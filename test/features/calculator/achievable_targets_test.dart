import 'package:flutter_test/flutter_test.dart';
import 'package:winemaker/core/models/alcohol.dart';
import 'package:winemaker/core/models/litres.dart';
import 'package:winemaker/core/models/sugar.dart';
import 'package:winemaker/features/calculator/domain/achievable_targets.dart';
import 'package:winemaker/features/calculator/domain/desired_wine.dart';
import 'package:winemaker/features/calculator/domain/ingredients_calculator.dart';
import 'package:winemaker/features/calculator/domain/must_measurements.dart';

const _must = MustMeasurements(Litres(10), Blg(20), GramsPerLiter(6));

void main() {
  group('targetLimits', () {
    test('acidity cap leaves no water to add', () {
      const target =
          DesiredWine(Alcohol(12), GramsPerLiter(20), GramsPerLiter(6));
      final capped = targetLimits(_must, target).maxAcidity;

      final result = calculateIngredients(
        DesiredWine(target.alcohol, target.sugar, capped),
        _must,
      );

      expect(capped.value, lessThan(_must.acidity.value));
      expect(result.water.value, equals(0));
    });

    test('just below the acidity cap still needs water', () {
      const target =
          DesiredWine(Alcohol(12), GramsPerLiter(20), GramsPerLiter(6));
      final capped = targetLimits(_must, target).maxAcidity;

      final result = calculateIngredients(
        DesiredWine(
            target.alcohol, target.sugar, GramsPerLiter(capped.value - 1)),
        _must,
      );

      expect(result.water.value, greaterThan(0));
    });

    test('alcohol floor leaves no sugar to add', () {
      const target =
          DesiredWine(Alcohol(12), GramsPerLiter(0), GramsPerLiter(6));
      final floor = targetLimits(_must, target).minAlcohol;

      final result = calculateIngredients(
        DesiredWine(floor, target.sugar, target.acidity),
        _must,
      );

      expect(floor.value, greaterThan(0));
      expect(result.sugar.value, equals(0));
    });

    test('just above the alcohol floor still needs sugar', () {
      const target =
          DesiredWine(Alcohol(12), GramsPerLiter(0), GramsPerLiter(6));
      final floor = targetLimits(_must, target).minAlcohol;

      final result = calculateIngredients(
        DesiredWine(Alcohol(floor.value + 1), target.sugar, target.acidity),
        _must,
      );

      expect(result.sugar.value, greaterThan(0));
    });

    test('sweetness eats into the sugar left for alcohol', () {
      const dry = DesiredWine(Alcohol(12), GramsPerLiter(0), GramsPerLiter(6));
      const sweet =
          DesiredWine(Alcohol(12), GramsPerLiter(60), GramsPerLiter(6));

      expect(
        targetLimits(_must, sweet).minAlcohol.value,
        lessThan(targetLimits(_must, dry).minAlcohol.value),
      );
    });

    test('a must with no sugar of its own imposes no alcohol floor', () {
      const poorMust = MustMeasurements(Litres(10), Blg(4), GramsPerLiter(6));
      const target =
          DesiredWine(Alcohol(12), GramsPerLiter(0), GramsPerLiter(6));

      expect(targetLimits(poorMust, target).minAlcohol.value, equals(0));
    });
  });
}
