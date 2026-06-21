import 'package:winemaker/features/recipe/domain/recipes.dart';

class RecipeRealization {
  final int currentTask;
  final AvailableRecipes recipe;

  const RecipeRealization(this.currentTask, this.recipe);
}
