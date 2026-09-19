import 'package:winemaker/features/realization/domain/task_state.dart';
import 'package:winemaker/features/recipe/domain/task.dart';

/// When work on one task occurrence started and finished.
///
/// A task is considered started when the one before it finished, so no extra
/// timestamp has to be stored. Fields are null for realizations made before
/// timestamps were recorded.
class TaskTiming {
  const TaskTiming({this.startedAt, this.completedAt});

  final DateTime? startedAt;
  final DateTime? completedAt;

  Duration? get duration {
    final start = startedAt;
    final end = completedAt;
    if (start == null || end == null || end.isBefore(start)) return null;
    return end.difference(start);
  }
}

TaskTiming taskTimingOf({
  required List<Task> tasks,
  required Map<RecipeTaskId, TaskStateRecord> states,
  required RecipeTaskId taskId,
  required DateTime realizationStart,
}) {
  final index = tasks.indexWhere((t) => t.id == taskId);
  if (index < 0) return const TaskTiming();
  return TaskTiming(
    startedAt: index == 0
        ? realizationStart
        : states[tasks[index - 1].id]?.completedAt,
    completedAt: states[taskId]?.completedAt,
  );
}
