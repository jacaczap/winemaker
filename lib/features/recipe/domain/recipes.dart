import 'package:winemaker/features/recipe/domain/recipe.dart';
import 'package:winemaker/features/recipe/domain/task.dart';
import 'package:winemaker/features/recipe/domain/task_type.dart';
import 'package:winemaker/l10n/app_localizations.dart';

const Recipe redWineRecipe = Recipe([
  Task(RecipeTaskId.prepareFruit, TaskType.description),
  Task(RecipeTaskId.initialSweetness, TaskType.initialMeasurement),
  Task(
    RecipeTaskId.addIngredients,
    TaskType.addingIngredients,
    ingredients: {IngredientKind.yeast, IngredientKind.nutrients},
  ),
  Task(
    RecipeTaskId.fermentWithSkins,
    TaskType.timeNotification,
    notification: TimeNotificationParams(
      delay: Duration(days: 7),
      postpone: Duration(days: 1),
    ),
  ),
  Task(RecipeTaskId.moveToCarboy, TaskType.description),
  Task(RecipeTaskId.calculations, TaskType.calculations),
  Task(
    RecipeTaskId.addWaterAndSugar,
    TaskType.addingIngredients,
    ingredients: {IngredientKind.water, IngredientKind.sugar},
  ),
  Task(
    RecipeTaskId.waitSugarDrop,
    TaskType.timeNotification,
    notification: TimeNotificationParams(
      delay: Duration(days: 14),
      postpone: Duration(days: 3),
    ),
  ),
  Task(
    RecipeTaskId.addRemainingSugar,
    TaskType.addingIngredients,
    ingredients: {IngredientKind.sugar},
  ),
  Task(
    RecipeTaskId.waitFermentationSlow,
    TaskType.timeNotification,
    notification: TimeNotificationParams(
      delay: Duration(days: 14),
      postpone: Duration(days: 7),
    ),
  ),
  Task(RecipeTaskId.rackWine, TaskType.description),
  Task(
    RecipeTaskId.matureWine,
    TaskType.timeNotification,
    notification: TimeNotificationParams(
      delay: Duration(days: 90),
      postpone: Duration(days: 14),
    ),
  ),
  Task(RecipeTaskId.rackWineAgain, TaskType.description),
  Task(
    RecipeTaskId.matureWineAgain,
    TaskType.timeNotification,
    notification: TimeNotificationParams(
      delay: Duration(days: 180),
      postpone: Duration(days: 14),
    ),
  ),
  Task(RecipeTaskId.bottleWine, TaskType.description),
  Task(RecipeTaskId.result, TaskType.result),
]);

/// Resolves the locale-specific name and description for a recipe task.
extension RecipeTaskTextExtension on RecipeTaskId {
  String displayName(AppLocalizations l10n) => switch (this) {
        RecipeTaskId.prepareFruit => l10n.taskPrepareFruitName,
        RecipeTaskId.initialSweetness => l10n.taskInitialSweetnessName,
        RecipeTaskId.calculations => l10n.taskCalculationsName,
        RecipeTaskId.addIngredients => l10n.taskAddIngredientsName,
        RecipeTaskId.fermentWithSkins => l10n.taskFermentWithSkinsName,
        RecipeTaskId.moveToCarboy => l10n.taskMoveToCarboyName,
        RecipeTaskId.addWaterAndSugar => l10n.taskAddWaterAndSugarName,
        RecipeTaskId.waitSugarDrop => l10n.taskWaitSugarDropName,
        RecipeTaskId.addRemainingSugar => l10n.taskAddRemainingSugarName,
        RecipeTaskId.waitFermentationSlow => l10n.taskWaitFermentationSlowName,
        RecipeTaskId.rackWine => l10n.taskRackWineName,
        RecipeTaskId.matureWine => l10n.taskMatureWineName,
        RecipeTaskId.rackWineAgain => l10n.taskRackWineAgainName,
        RecipeTaskId.matureWineAgain => l10n.taskMatureWineAgainName,
        RecipeTaskId.bottleWine => l10n.taskBottleWineName,
        RecipeTaskId.result => l10n.taskResultName,
      };

  String? description(AppLocalizations l10n) => switch (this) {
        RecipeTaskId.prepareFruit => l10n.taskPrepareFruitDescription,
        RecipeTaskId.initialSweetness =>
          l10n.taskInitialSweetnessDescription,
        RecipeTaskId.calculations => l10n.taskCalculationsDescription,
        RecipeTaskId.addIngredients => l10n.taskAddIngredientsDescription,
        RecipeTaskId.fermentWithSkins => l10n.taskFermentWithSkinsDescription,
        RecipeTaskId.moveToCarboy => l10n.taskMoveToCarboyDescription,
        RecipeTaskId.addWaterAndSugar => l10n.taskAddWaterAndSugarDescription,
        RecipeTaskId.waitSugarDrop => l10n.taskWaitSugarDropDescription,
        RecipeTaskId.addRemainingSugar => l10n.taskAddRemainingSugarDescription,
        RecipeTaskId.waitFermentationSlow =>
          l10n.taskWaitFermentationSlowDescription,
        RecipeTaskId.rackWine => l10n.taskRackWineDescription,
        RecipeTaskId.matureWine => l10n.taskMatureWineDescription,
        RecipeTaskId.rackWineAgain => l10n.taskRackWineAgainDescription,
        RecipeTaskId.matureWineAgain => l10n.taskMatureWineAgainDescription,
        RecipeTaskId.bottleWine => l10n.taskBottleWineDescription,
        RecipeTaskId.result => null,
      };
}

enum AvailableRecipes {
  redWine,
}

extension AvaliableRecipesExtension on AvailableRecipes {
  Recipe getRecipe() {
    switch (this) {
      case AvailableRecipes.redWine:
        return redWineRecipe;
    }
  }

  String displayName(AppLocalizations l10n) {
    switch (this) {
      case AvailableRecipes.redWine:
        return l10n.recipeRedWine;
    }
  }
}
