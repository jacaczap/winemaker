import 'package:flutter_test/flutter_test.dart';
import 'package:winemaker/features/realization/domain/task_state.dart';
import 'package:winemaker/features/realization/domain/task_timing.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/features/recipe/domain/task.dart';

/// How long a step took is derived, not stored: a step starts when the one
/// before it finished.
void main() {
  final tasks = redWineRecipe.tasks;
  final start = DateTime(2026, 3, 1);

  TaskStateRecord completedAt(RecipeTaskId taskId, DateTime when) =>
      TaskStateRecord(
        realizationId: 1,
        taskId: taskId,
        status: TaskState.completed,
        payloadJson: null,
        completedAt: when,
      );

  test('the first task is measured from the start of the realization', () {
    final timing = taskTimingOf(
      tasks: tasks,
      states: {
        tasks.first.id: completedAt(tasks.first.id, DateTime(2026, 3, 3)),
      },
      taskId: tasks.first.id,
      realizationStart: start,
    );

    expect(timing.duration, equals(const Duration(days: 2)));
  });

  test('a later task is measured from the previous completion', () {
    final timing = taskTimingOf(
      tasks: tasks,
      states: {
        tasks[0].id: completedAt(tasks[0].id, DateTime(2026, 3, 3)),
        tasks[1].id: completedAt(tasks[1].id, DateTime(2026, 3, 10)),
      },
      taskId: tasks[1].id,
      realizationStart: start,
    );

    expect(timing.duration, equals(const Duration(days: 7)));
  });

  test('no duration when the previous task has no timestamp', () {
    final timing = taskTimingOf(
      tasks: tasks,
      states: {
        tasks[1].id: completedAt(tasks[1].id, DateTime(2026, 3, 10)),
      },
      taskId: tasks[1].id,
      realizationStart: start,
    );

    expect(timing.completedAt, equals(DateTime(2026, 3, 10)));
    expect(timing.duration, isNull);
  });

  test('an unfinished task has no duration', () {
    final timing = taskTimingOf(
      tasks: tasks,
      states: const {},
      taskId: tasks.first.id,
      realizationStart: start,
    );

    expect(timing.completedAt, isNull);
    expect(timing.duration, isNull);
  });
}
