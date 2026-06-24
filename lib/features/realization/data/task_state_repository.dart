import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/features/realization/domain/task_state.dart';

part 'task_state_repository.g.dart';

/// Single source of truth for per-task progress and per-task data.
///
/// Backed by the unified `realization_task_state` table keyed by
/// `(realizationId, taskIndex)`. Supports repeatable tasks (same task type at
/// multiple indices), jump-back-discard (delete rows after a target index)
/// and read-only inspection of completed occurrences.
class TaskStateRepository {
  TaskStateRepository(this._database);

  final MyDatabase _database;

  Future<TaskStateRecord?> get(int realizationId, int taskIndex) => _database
      .taskStateDao
      .byKey(realizationId, taskIndex)
      .then((data) => data?.toDomain());

  Future<List<TaskStateRecord>> listForRealization(int realizationId) =>
      _database.taskStateDao.forRealization(realizationId).then(
          (rows) => rows.map((r) => r.toDomain()).toList(growable: false));

  Stream<List<TaskStateRecord>> watchForRealization(int realizationId) =>
      _database.taskStateDao
          .watchForRealization(realizationId)
          .map((rs) => rs.map((r) => r.toDomain()).toList(growable: false));

  Future<void> markCompleted(
    int realizationId,
    int taskIndex, {
    TaskPayload? payload,
  }) =>
      _upsert(realizationId, taskIndex, TaskState.completed, payload);

  Future<void> savePending(
    int realizationId,
    int taskIndex, {
    TaskPayload? payload,
  }) =>
      _upsert(realizationId, taskIndex, TaskState.pending, payload);

  /// Discards every task state row with `taskIndex > fromTaskIndex`.
  ///
  /// Use when the user jumps back to `fromTaskIndex`: the target task's data
  /// is preserved (the user may re-edit or override it), only strictly later
  /// occurrences are wiped.
  Future<void> discardAfter(int realizationId, int fromTaskIndex) =>
      _database.taskStateDao.deleteAfter(realizationId, fromTaskIndex);

  Future<void> deleteAt(int realizationId, int taskIndex) =>
      _database.taskStateDao.deleteByKey(realizationId, taskIndex);

  Future<void> deleteAllFor(int realizationId) =>
      _database.taskStateDao.deleteAllFor(realizationId);

  Future<void> _upsert(
    int realizationId,
    int taskIndex,
    TaskState status,
    TaskPayload? payload,
  ) =>
      _database.taskStateDao.upsert(TaskStateEntityData(
        realizationId: realizationId,
        taskIndex: taskIndex,
        status: status,
        payload: payload == null ? null : jsonEncode(payload.toJson()),
      ));
}

@riverpod
TaskStateRepository taskStateRepository(Ref ref) =>
    TaskStateRepository(ref.watch(databaseProvider));

extension _TaskStateEntityDataExtension on TaskStateEntityData {
  TaskStateRecord toDomain() => TaskStateRecord(
        realizationId: realizationId,
        taskIndex: taskIndex,
        status: status,
        payloadJson: payload == null
            ? null
            : jsonDecode(payload!) as Map<String, dynamic>,
      );
}
