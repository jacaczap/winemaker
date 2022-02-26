import 'package:winemaker/src/constants/recipes.dart';

class RecipeRealization {
  final int currentTask;
  final AvailableRecipes recipe;

  const RecipeRealization(this.currentTask, this.recipe);
}
