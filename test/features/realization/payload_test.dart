import 'package:flutter_test/flutter_test.dart';
import 'package:winemaker/core/models/alcohol.dart';
import 'package:winemaker/core/models/litres.dart';
import 'package:winemaker/core/models/sugar.dart';
import 'package:winemaker/features/calculator/domain/desired_wine.dart';
import 'package:winemaker/features/calculator/domain/ingredients.dart';
import 'package:winemaker/features/calculator/domain/must_measurements.dart';
import 'package:winemaker/features/realization/domain/calculations_payload.dart';
import 'package:winemaker/features/realization/domain/result_payload.dart';
import 'package:winemaker/features/realization/domain/time_notification_payload.dart';

void main() {
  test('CalculationsPayload round-trips through json', () {
    const payload = CalculationsPayload(
      desiredWine: DesiredWine(Alcohol(13), GramsPerLiter(20), GramsPerLiter(7)),
      must: MustMeasurements(Litres(10), Blg(15), GramsPerLiter(9)),
      ingredients: Ingredients(Kilograms(2.5), Litres(1.2), true, true),
    );

    final decoded = CalculationsPayload.fromJson(payload.toJson());

    expect(decoded.desiredWine.alcohol.value, equals(13));
    expect(decoded.desiredWine.sugar.value, equals(20));
    expect(decoded.desiredWine.acidity.value, equals(7));
    expect(decoded.must.volume.value, equals(10));
    expect(decoded.must.sugar.value, equals(15));
    expect(decoded.must.acidity.value, equals(9));
    expect(decoded.ingredients.sugar.value, equals(2.5));
    expect(decoded.ingredients.water.value, equals(1.2));
    expect(decoded.ingredients.yeast, isTrue);
    expect(decoded.ingredients.nutrients, isTrue);
  });

  test('ResultPayload round-trips and defaults missing fields', () {
    const payload = ResultPayload(results: 'good', mistakes: 'none');
    final decoded = ResultPayload.fromJson(payload.toJson());
    expect(decoded.results, equals('good'));
    expect(decoded.mistakes, equals('none'));

    final fromEmpty = ResultPayload.fromJson(const {});
    expect(fromEmpty.results, isEmpty);
    expect(fromEmpty.mistakes, isEmpty);
  });

  test('TimeNotificationPayload round-trips to the same instant', () {
    final payload = TimeNotificationPayload(
      scheduledFor: DateTime.fromMillisecondsSinceEpoch(1700000000000),
    );

    final decoded = TimeNotificationPayload.fromJson(payload.toJson());

    expect(
      decoded.scheduledFor.millisecondsSinceEpoch,
      equals(1700000000000),
    );
  });
}
