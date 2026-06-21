import 'package:flutter_test/flutter_test.dart';
import 'package:winemaker/core/models/alcohol.dart';
import 'package:winemaker/core/models/litres.dart';
import 'package:winemaker/core/models/sugar.dart';
import 'package:winemaker/features/calculator/domain/desired_wine.dart';
import 'package:winemaker/features/calculator/domain/ingredients_calculator.dart';
import 'package:winemaker/features/calculator/domain/must_measurements.dart';

void main() {
  test('Should calculate ingredients with acidity-driven dilution', () {
    const desiredWine = DesiredWine(Alcohol(17), GramsPerLiter(25), GramsPerLiter(9));
    const must = MustMeasurements(Litres(14), Blg(11), GramsPerLiter(14));

    var result = calculateIngredients(desiredWine, must);

    expect(result.sugar.value, equals(5.88));
    expect(result.water.value, equals(4.31));
    expect(result.yeast, equals(true));
    expect(result.nutrients, equals(true));
  });
}
