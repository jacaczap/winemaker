import 'package:drift/drift.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/features/realization/data/task_state_entity.dart';

part 'task_state_dao.g.dart';

@DriftAccessor(tables: [TaskStateEntity])
class TaskStateDao extends DatabaseAccessor<MyDatabase>
    with _$TaskStateDaoMixin {
  TaskStateDao(super.db);

  Future<TaskStateEntityData?> byKey(int realizationId, int taskIndex) =>
      (select(taskStateEntity)
            ..where((t) =>
                t.realizationId.equals(realizationId) &
                t.taskIndex.equals(taskIndex)))
          .getSingleOrNull();

  Future<List<TaskStateEntityData>> forRealization(int realizationId) =>
      (select(taskStateEntity)
            ..where((t) => t.realizationId.equals(realizationId))
            ..orderBy([(t) => OrderingTerm.asc(t.taskIndex)]))
          .get();

  Stream<List<TaskStateEntityData>> watchForRealization(int realizationId) =>
      (select(taskStateEntity)
            ..where((t) => t.realizationId.equals(realizationId))
            ..orderBy([(t) => OrderingTerm.asc(t.taskIndex)]))
          .watch();

  Future<void> upsert(TaskStateEntityData row) =>
      into(taskStateEntity).insertOnConflictUpdate(row);

  Future<int> deleteByKey(int realizationId, int taskIndex) =>
      (delete(taskStateEntity)
            ..where((t) =>
                t.realizationId.equals(realizationId) &
                t.taskIndex.equals(taskIndex)))
          .go();

  Future<int> deleteAfter(int realizationId, int taskIndex) =>
      (delete(taskStateEntity)
            ..where((t) =>
                t.realizationId.equals(realizationId) &
                t.taskIndex.isBiggerThanValue(taskIndex)))
          .go();

  Future<int> deleteAllFor(int realizationId) =>
      (delete(taskStateEntity)
            ..where((t) => t.realizationId.equals(realizationId)))
          .go();
}
