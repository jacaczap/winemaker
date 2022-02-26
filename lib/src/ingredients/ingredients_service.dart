import 'dart:developer' as developer;

import 'package:flutter/widgets.dart';
import 'package:winemaker/src/common_models/litres.dart';
import 'package:winemaker/src/common_models/sugar.dart';
import 'package:winemaker/src/database/database.dart';
import 'package:winemaker/src/database/drift_value_extension.dart';
import 'package:winemaker/src/desired_wine/desired_wine.dart';
import 'package:winemaker/src/future/future_mapper.dart';
import 'package:winemaker/src/must/must_measurements.dart';

import '_ingredients_calculator.dart';
import 'ingredients.dart';

Future<void> calculateAndSaveIngredients(
  Future<DesiredWine> _desiredWine,
  Future<MustMeasurements> _must,
  BuildContext context,
) async {
  var desiredWine = await _desiredWine;
  var must = await _must;
  var ingredients = calculateIngredients(desiredWine, must);
  _saveInitialIngredients(ingredients, context);
}

void saveAddedIngredients(int id, Ingredients addedIngredients, BuildContext context) {
  var database = getDatabase(context);
  database.ingredientsDao.updateIngredients(
    id,
    addedIngredients.toEntityCompanion(),
  );
}

Future<Ingredients> getRemainingIngredients(int id, BuildContext context) {
  var database = getDatabase(context);
  return database.ingredientsDao.ingredientsById(id).map((data) => data.toRemainingIngredients());
}

void _saveInitialIngredients(Ingredients requiredIngredients, BuildContext context) {
  var database = getDatabase(context);
  database.ingredientsDao.addIngredients(requiredIngredients.toInitialEntityData());
  developer.log("Initial ingredients saved!");
}

extension _IngredientsExtension on Ingredients {
  IngredientsEntityCompanion toEntityCompanion() => IngredientsEntityCompanion(
        addedSugar: sugar.value.toDriftValue(),
        addedWater: water.value.toDriftValue(),
        addedYeast: yeast.toDriftValue(),
        addedNutrients: nutrients.toDriftValue(),
      );

  IngredientsEntityData toInitialEntityData() {
    const initialZero = 0.0;
    const initialFalse = false;

    return IngredientsEntityData(
      id: 1,
      requiredSugar: sugar.value,
      addedSugar: initialZero,
      requiredWater: water.value,
      addedWater: initialZero,
      requiredYeast: yeast,
      addedYeast: initialFalse,
      requiredNutrients: nutrients,
      addedNutrients: initialFalse,
    );
  }
}

extension _IngredientsEntityDataExtension on IngredientsEntityData {
  Ingredients toRemainingIngredients() => Ingredients(
        Kilograms(requiredSugar - addedSugar),
        Litres(requiredWater - addedWater),
        requiredYeast != addedYeast,
        requiredNutrients != addedNutrients,
      );
}
