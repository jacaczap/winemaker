import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/l10n/app_localizations.dart';

class RecipeRealization {
  final int id;
  final int currentTask;
  final AvailableRecipes recipe;
  final String? name;
  final DateTime startTime;
  final bool completed;

  const RecipeRealization({
    required this.id,
    required this.currentTask,
    required this.recipe,
    this.name,
    required this.startTime,
    required this.completed,
  });

  /// The user-facing title: the custom name if set, otherwise the recipe name.
  String displayName(AppLocalizations l10n) =>
      name?.trim().isNotEmpty == true ? name!.trim() : recipe.displayName(l10n);

  RecipeRealization copyWith({int? currentTask, String? name, bool? completed}) =>
      RecipeRealization(
        id: id,
        currentTask: currentTask ?? this.currentTask,
        recipe: recipe,
        name: name ?? this.name,
        startTime: startTime,
        completed: completed ?? this.completed,
      );
}
