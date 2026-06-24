import 'task_type.dart';

/// Stable identifier for a task in a built-in recipe.
///
/// Decouples a task from its user-facing text so the name and description can
/// be resolved per locale (see `RecipeTaskTextExtension` in `recipes.dart`).
enum RecipeTaskId {
  prepareFruit,
  calculations,
  addIngredients,
  fermentWithSkins,
  moveToCarboy,
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

class Task {
  final RecipeTaskId id;
  final TaskType type;
  final TimeNotificationParams? notification;

  const Task(this.id, this.type, {this.notification});
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
