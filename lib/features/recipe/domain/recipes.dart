import 'package:winemaker/features/recipe/domain/recipe.dart';
import 'package:winemaker/features/recipe/domain/task.dart';
import 'package:winemaker/features/recipe/domain/task_type.dart';

// Remaining tasks are repopulated by the feature todos
// (addingIngredientsRepeat, resultTask, redWineRecipe) once those task types
// are implemented against TaskStateRepository.
const Recipe redWineRecipe = Recipe([
  Task('Setup', TaskType.setup),
]);

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
