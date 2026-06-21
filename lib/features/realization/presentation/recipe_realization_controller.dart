import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/features/realization/data/recipe_realization_repository.dart';
import 'package:winemaker/features/realization/domain/recipe_realization.dart';

part 'recipe_realization_controller.g.dart';

@riverpod
class RecipeRealizationController extends _$RecipeRealizationController {
  @override
  Future<RecipeRealization> build(int id) async {
    final repository = ref.watch(recipeRealizationRepositoryProvider);
    final existing = await repository.byId(id);
    if (existing != null) return existing;
    const initial = RecipeRealization(0, AvailableRecipes.redWine);
    await repository.saveInitial(id, initial);
    return initial;
  }

  Future<void> completeCurrentTask() async {
    final current = state.value;
    if (current == null) return;
    final totalTasks = current.recipe.getRecipe().tasks.length;
    final next = current.currentTask + 1;
    if (next > totalTasks) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(recipeRealizationRepositoryProvider)
          .updateCurrentTask(id, next);
      return RecipeRealization(next, current.recipe);
    });
  }

  Future<void> revertCurrentTask() async {
    final current = state.value;
    if (current == null) return;
    if (current.currentTask <= 0) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(recipeRealizationRepositoryProvider)
          .revertCurrentTask(id, current.currentTask);
      return RecipeRealization(current.currentTask - 1, current.recipe);
    });
  }
}
