import 'package:winemaker/core/models/alcohol.dart';
import 'package:winemaker/core/models/litres.dart';
import 'package:winemaker/core/models/sugar.dart';
import 'package:winemaker/features/calculator/domain/desired_wine.dart';
import 'package:winemaker/features/calculator/domain/ingredients.dart';
import 'package:winemaker/features/calculator/domain/must_measurements.dart';
import 'package:winemaker/features/realization/domain/task_state.dart';

/// Per-occurrence data for a `calculations` task.
///
/// Stores the inputs the user entered (desired wine + must measurements) and
/// the ingredients calculated from them, so the screen can be inspected or
/// re-edited later without recomputing.
class CalculationsPayload extends TaskPayload {
  const CalculationsPayload({
    required this.desiredWine,
    required this.must,
    required this.ingredients,
  });

  factory CalculationsPayload.fromJson(Map<String, dynamic> json) =>
      CalculationsPayload(
        desiredWine: DesiredWine(
          Alcohol((json['desiredAlcohol'] as num).toDouble()),
          GramsPerLiter((json['desiredSweetness'] as num).toDouble()),
          GramsPerLiter((json['desiredAcidity'] as num).toDouble()),
        ),
        must: MustMeasurements(
          Litres((json['mustVolume'] as num).toDouble()),
          Blg((json['mustSugar'] as num).toDouble()),
          GramsPerLiter((json['mustAcidity'] as num).toDouble()),
        ),
        ingredients: Ingredients(
          Kilograms((json['sugarToAdd'] as num).toDouble()),
          Litres((json['waterToAdd'] as num).toDouble()),
          json['yeast'] as bool,
          json['nutrients'] as bool,
        ),
      );

  final DesiredWine desiredWine;
  final MustMeasurements must;
  final Ingredients ingredients;

  @override
  Map<String, dynamic> toJson() => {
        'desiredAlcohol': desiredWine.alcohol.value,
        'desiredSweetness': desiredWine.sugar.value,
        'desiredAcidity': desiredWine.acidity.value,
        'mustVolume': must.volume.value,
        'mustSugar': must.sugar.value,
        'mustAcidity': must.acidity.value,
        'sugarToAdd': ingredients.sugar.value,
        'waterToAdd': ingredients.water.value,
        'yeast': ingredients.yeast,
        'nutrients': ingredients.nutrients,
      };
}
