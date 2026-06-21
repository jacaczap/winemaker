import 'package:winemaker/features/recipe/domain/recipes.dart';

class RecipeRealization {
  final int id;
  final int currentTask;
  final AvailableRecipes recipe;
  final DateTime startTime;
  final bool completed;

  const RecipeRealization({
    required this.id,
    required this.currentTask,
    required this.recipe,
    required this.startTime,
    required this.completed,
  });

  RecipeRealization copyWith({int? currentTask, bool? completed}) =>
      RecipeRealization(
        id: id,
        currentTask: currentTask ?? this.currentTask,
        recipe: recipe,
        startTime: startTime,
        completed: completed ?? this.completed,
      );
}
