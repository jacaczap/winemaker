import 'task_type.dart';

/// Stable identifier for a task in a built-in recipe.
///
/// Decouples a task from its user-facing text so the name and description can
/// be resolved per locale (see `RecipeTaskTextExtension` in `recipes.dart`),
/// and keys the stored per-task state so reordering a recipe does not move
/// data between tasks.
enum RecipeTaskId {
  prepareFruit,
  initialSweetness,
  addIngredients,
  fermentWithSkins,
  moveToCarboy,
  calculations,
  addWaterAndSugar,
  waitSugarDrop,
  addRemainingSugar,
  waitFermentationSlow,
  rackWine,
  matureWine,
  rackWineAgain,
  matureWineAgain,
  bottleWine,
  result,
}

/// An ingredient a [TaskType.addingIngredients] task asks the user about.
enum IngredientKind {
  sugar,
  water,
  yeast,
  nutrients,
}

class Task {
  final RecipeTaskId id;
  final TaskType type;
  final TimeNotificationParams? notification;

  /// Which ingredients a [TaskType.addingIngredients] task collects. Ignored
  /// by every other task type.
  final Set<IngredientKind> ingredients;

  const Task(
    this.id,
    this.type, {
    this.notification,
    this.ingredients = const {},
  });
}

/// Timing parameters for a [TaskType.timeNotification] task.
///
/// [delay] is how long to wait before the reminder fires; [postpone] is how
/// far each "postpone" pushes it back.
class TimeNotificationParams {
  final Duration delay;
  final Duration postpone;

  const TimeNotificationParams({required this.delay, required this.postpone});
}
