import 'package:winemaker/features/recipe/domain/recipe.dart';

// Tasks will be repopulated by the feature todos (setupTaskMerge,
// addingIngredientsRepeat, resultTask, redWineRecipe) once those task types
// are implemented against TaskStateRepository.
const Recipe redWineRecipe = Recipe([]);

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

  String get displayName {
    switch (this) {
      case AvailableRecipes.redWine:
        return 'Red Wine';
    }
  }
}
