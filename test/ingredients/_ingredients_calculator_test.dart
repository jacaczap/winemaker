import 'package:flutter_test/flutter_test.dart';
import 'package:winemaker/core/models/alcohol.dart';
import 'package:winemaker/core/models/litres.dart';
import 'package:winemaker/core/models/sugar.dart';
import 'package:winemaker/features/calculator/domain/desired_wine.dart';
import 'package:winemaker/features/calculator/domain/ingredients_calculator.dart';
import 'package:winemaker/features/calculator/domain/must_measurements.dart';

void main() {
  test('Should calculate ingredients', () {
    const desiredWine = DesiredWine(Alcohol(16), GramsPerLiter(25));
    const must = MustMeasurements(Litres(21.5), Blg(16));

    var result = calculateIngredients(desiredWine, must);

    expect(result.sugar.value, equals(5.40));
    expect(result.water.value, equals(2.13));
    expect(result.yeast, equals(true));
    expect(result.nutrients, equals(true));
  });
}
