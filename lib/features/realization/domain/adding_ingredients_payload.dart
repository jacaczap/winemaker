import 'package:winemaker/core/models/litres.dart';
import 'package:winemaker/core/models/sugar.dart';
import 'package:winemaker/features/calculator/domain/ingredients.dart';
import 'package:winemaker/features/realization/domain/task_state.dart';

/// Per-occurrence data for an `addingIngredients` task.
///
/// Stores how much was added in this single occurrence. The calculated total
/// lives in the `calculations` task payload; remaining-to-add is derived by
/// subtracting prior occurrences' [added] amounts from that total.
class AddingIngredientsPayload extends TaskPayload {
  const AddingIngredientsPayload({required this.added});

  factory AddingIngredientsPayload.fromJson(Map<String, dynamic> json) =>
      AddingIngredientsPayload(
        added: Ingredients(
          Kilograms((json['addedSugar'] as num).toDouble()),
          Litres((json['addedWater'] as num).toDouble()),
          json['addedYeast'] as bool,
          json['addedNutrients'] as bool,
        ),
      );

  final Ingredients added;

  @override
  Map<String, dynamic> toJson() => {
        'addedSugar': added.sugar.value,
        'addedWater': added.water.value,
        'addedYeast': added.yeast,
        'addedNutrients': added.nutrients,
      };
}
