import 'package:drift/drift.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/features/realization/data/task_state_entity.dart';
import 'package:winemaker/features/realization/domain/task_state.dart';
import 'package:winemaker/features/recipe/domain/task.dart';

part 'task_state_dao.g.dart';

@DriftAccessor(tables: [TaskStateEntity])
class TaskStateDao extends DatabaseAccessor<MyDatabase>
    with _$TaskStateDaoMixin {
  TaskStateDao(super.db);

  Future<TaskStateEntityData?> byKey(int realizationId, RecipeTaskId taskId) =>
      (select(taskStateEntity)
            ..where((t) =>
                t.realizationId.equals(realizationId) &
                t.taskId.equalsValue(taskId)))
          .getSingleOrNull();

  Future<List<TaskStateEntityData>> forRealization(int realizationId) =>
      (select(taskStateEntity)
            ..where((t) => t.realizationId.equals(realizationId)))
          .get();

  Stream<List<TaskStateEntityData>> watchForRealization(int realizationId) =>
      (select(taskStateEntity)
            ..where((t) => t.realizationId.equals(realizationId)))
          .watch();

  /// Upserts the columns present in [row], leaving absent ones untouched.
  Future<void> upsert(TaskStateEntityCompanion row) =>
      into(taskStateEntity).insertOnConflictUpdate(row);

  /// Writes only the note, so it can be added to a completed task without
  /// disturbing its status, payload or completion time.
  Future<void> upsertNotes(
    int realizationId,
    RecipeTaskId taskId,
    String? notes,
  ) =>
      into(taskStateEntity).insert(
        TaskStateEntityCompanion.insert(
          realizationId: realizationId,
          taskId: taskId,
          status: TaskState.pending,
          notes: Value(notes),
        ),
        onConflict: DoUpdate(
          (_) => TaskStateEntityCompanion(notes: Value(notes)),
        ),
      );

  Future<int> deleteForIds(
    int realizationId,
    Iterable<RecipeTaskId> taskIds,
  ) =>
      (delete(taskStateEntity)
            ..where((t) =>
                t.realizationId.equals(realizationId) &
                t.taskId.isInValues(taskIds)))
          .go();

  Future<int> deleteAllFor(int realizationId) => (delete(taskStateEntity)
        ..where((t) => t.realizationId.equals(realizationId)))
      .go();
}
