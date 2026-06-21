import 'package:flutter_test/flutter_test.dart';
import 'package:winemaker/core/models/alcohol.dart';
import 'package:winemaker/core/models/litres.dart';
import 'package:winemaker/core/models/sugar.dart';
import 'package:winemaker/features/calculator/domain/desired_wine.dart';
import 'package:winemaker/features/calculator/domain/ingredients_calculator.dart';
import 'package:winemaker/features/calculator/domain/must_measurements.dart';

void main() {
  group('calculateIngredients', () {
    test('uses acidity ratio to drive dilution', () {
      const desiredWine =
          DesiredWine(Alcohol(17), GramsPerLiter(25), GramsPerLiter(9));
      const must = MustMeasurements(Litres(14), Blg(11), GramsPerLiter(14));

      final result = calculateIngredients(desiredWine, must);

      expect(result.sugar.value, equals(5.88));
      expect(result.water.value, equals(4.31));
      expect(result.yeast, isTrue);
      expect(result.nutrients, isTrue);
    });

    test('clamps dilution at zero when must is less acidic than target', () {
      const desiredWine =
          DesiredWine(Alcohol(12), GramsPerLiter(0), GramsPerLiter(9));
      const must = MustMeasurements(Litres(10), Blg(20), GramsPerLiter(5));

      final result = calculateIngredients(desiredWine, must);

      expect(result.water.value, lessThanOrEqualTo(0));
    });

    test('adds water proportionally when must is too acidic', () {
      const desiredWine =
          DesiredWine(Alcohol(0), GramsPerLiter(0), GramsPerLiter(5));
      const must = MustMeasurements(Litres(5), Blg(4), GramsPerLiter(10));

      final result = calculateIngredients(desiredWine, must);

      expect(result.sugar.value, equals(0));
      expect(result.water.value, equals(5));
    });

    test('returns no dilution when desired acidity is non-positive', () {
      const desiredWine =
          DesiredWine(Alcohol(10), GramsPerLiter(0), GramsPerLiter(0));
      const must = MustMeasurements(Litres(10), Blg(4), GramsPerLiter(8));

      final result = calculateIngredients(desiredWine, must);

      expect(result.sugar.value, equals(1.7));
      expect(result.water.value, equals(-1.02));
    });

    test('always recommends yeast and nutrients', () {
      const desiredWine =
          DesiredWine(Alcohol(5), GramsPerLiter(10), GramsPerLiter(7));
      const must = MustMeasurements(Litres(8), Blg(12), GramsPerLiter(7));

      final result = calculateIngredients(desiredWine, must);

      expect(result.yeast, isTrue);
      expect(result.nutrients, isTrue);
    });
  });
}
