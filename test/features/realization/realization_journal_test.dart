import 'package:flutter_test/flutter_test.dart';
import 'package:winemaker/features/realization/domain/realization_journal.dart';
import 'package:winemaker/features/realization/domain/task_state.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/features/recipe/domain/task.dart';

/// The journal groups finished steps by the day they were done and measures
/// the gap between those days.
void main() {
  final tasks = redWineRecipe.tasks;

  TaskStateRecord record(RecipeTaskId taskId, DateTime? when, {String? notes}) =>
      TaskStateRecord(
        realizationId: 1,
        taskId: taskId,
        status: TaskState.completed,
        payloadJson: null,
        notes: notes,
        completedAt: when,
      );

  test('steps finished on the same day share one day, hours apart', () {
    final days = buildJournal(
      tasks: tasks,
      states: {
        tasks[0].id: record(tasks[0].id, DateTime(2026, 3, 1, 9)),
        tasks[1].id: record(tasks[1].id, DateTime(2026, 3, 1, 20)),
      },
      completedTaskCount: 2,
    );

    expect(days, hasLength(1));
    expect(days.single.date, equals(DateTime(2026, 3, 1)));
    expect(days.single.entries, hasLength(2));
    expect(days.single.daysSincePrevious, isNull);
  });

  test('a new calendar day starts a new day with the gap in days', () {
    final days = buildJournal(
      tasks: tasks,
      states: {
        tasks[0].id: record(tasks[0].id, DateTime(2026, 3, 1, 23)),
        tasks[1].id: record(tasks[1].id, DateTime(2026, 3, 2, 1)),
        tasks[2].id: record(tasks[2].id, DateTime(2026, 3, 26, 12)),
      },
      completedTaskCount: 3,
    );

    expect(days.map((d) => d.daysSincePrevious), equals([null, 1, 24]));
  });

  test('steps without a timestamp are listed with no date and no gap', () {
    final days = buildJournal(
      tasks: tasks,
      states: {
        tasks[0].id: record(tasks[0].id, null, notes: 'from an old version'),
        tasks[1].id: record(tasks[1].id, DateTime(2026, 3, 5)),
      },
      completedTaskCount: 2,
    );

    expect(days.first.date, isNull);
    expect(days.first.daysSincePrevious, isNull);
    expect(days.first.entries.single.notes, equals('from an old version'));
    expect(days.last.daysSincePrevious, isNull);
  });

  test('unfinished steps are left out', () {
    final days = buildJournal(
      tasks: tasks,
      states: {tasks[0].id: record(tasks[0].id, DateTime(2026, 3, 1))},
      completedTaskCount: 1,
    );

    expect(days.single.entries.single.task.id, equals(tasks[0].id));
  });
}
