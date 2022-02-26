import 'package:flutter_test/flutter_test.dart';
import 'package:winemaker/src/common_models/alcohol.dart';
import 'package:winemaker/src/common_models/litres.dart';
import 'package:winemaker/src/common_models/sugar.dart';
import 'package:winemaker/src/desired_wine/desired_wine.dart';
import 'package:winemaker/src/ingredients/_ingredients_calculator.dart';
import 'package:winemaker/src/must/must_measurements.dart';

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
