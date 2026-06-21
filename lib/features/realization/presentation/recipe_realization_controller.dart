import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winemaker/core/notifications/notification_service.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/features/recipe/domain/task_type.dart';
import 'package:winemaker/features/realization/data/recipe_realization_repository.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/realization/domain/recipe_realization.dart';

part 'recipe_realization_controller.g.dart';

@riverpod
class RecipeRealizationController extends _$RecipeRealizationController {
  @override
  Future<RecipeRealization> build(int id) async {
    final existing =
        await ref.watch(recipeRealizationRepositoryProvider).byId(id);
    if (existing == null) {
      throw StateError('Realization $id not found');
    }
    return existing;
  }

  Future<void> completeCurrentTask() async {
    final current = state.value;
    if (current == null) return;
    final totalTasks = current.recipe.getRecipe().tasks.length;
    final next = current.currentTask + 1;
    if (next > totalTasks) return;
    final completed = next >= totalTasks;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(recipeRealizationRepositoryProvider)
          .updateCurrentTask(id, next, completed: completed);
      return current.copyWith(currentTask: next, completed: completed);
    });
  }

  /// Jumps back to an earlier task and discards everything after it.
  ///
  /// The target becomes the current task again; data of all later occurrences
  /// is deleted and any pending `timeNotification` reminders among them are
  /// cancelled. Jumping forward or to the current task is a no-op.
  Future<void> jumpToTask(int targetIndex) async {
    final current = state.value;
    if (current == null) return;
    if (targetIndex < 0 || targetIndex >= current.currentTask) return;
    final tasks = current.recipe.getRecipe().tasks;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(taskStateRepositoryProvider)
          .discardAfter(id, targetIndex);
      final notifications = ref.read(notificationServiceProvider);
      for (var i = targetIndex + 1; i < tasks.length; i++) {
        if (tasks[i].type == TaskType.timeNotification) {
          await notifications.cancel(id, i);
        }
      }
      await ref
          .read(recipeRealizationRepositoryProvider)
          .updateCurrentTask(id, targetIndex, completed: false);
      return current.copyWith(currentTask: targetIndex, completed: false);
    });
  }
}

/// Home-list controller: streams all realizations and owns create/delete.
@riverpod
class RecipeRealizationsController extends _$RecipeRealizationsController {
  @override
  Stream<List<RecipeRealization>> build() =>
      ref.watch(recipeRealizationRepositoryProvider).watchAll();

  Future<int> create(AvailableRecipes recipe) =>
      ref.read(recipeRealizationRepositoryProvider).create(recipe);

  Future<void> delete(int id) =>
      ref.read(recipeRealizationRepositoryProvider).delete(id);
}
