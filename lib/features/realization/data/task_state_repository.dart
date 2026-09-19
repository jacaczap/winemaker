import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/features/realization/domain/task_state.dart';
import 'package:winemaker/features/recipe/domain/task.dart';

part 'task_state_repository.g.dart';

/// Single source of truth for per-task progress and per-task data.
///
/// Backed by the unified `task_state_entity` table keyed by
/// `(realizationId, taskId)`. Keying on the task's stable id rather than its
/// position means reordering a recipe never moves data between tasks. Rows are
/// optional: a task that stores nothing (e.g. a description the user merely
/// acknowledged) has no row at all, and progress is tracked by the
/// realization's task pointer.
class TaskStateRepository {
  TaskStateRepository(this._database);

  final MyDatabase _database;

  Future<TaskStateRecord?> get(int realizationId, RecipeTaskId taskId) =>
      _database.taskStateDao
          .byKey(realizationId, taskId)
          .then((data) => data?.toDomain());

  Future<List<TaskStateRecord>> listForRealization(int realizationId) =>
      _database.taskStateDao.forRealization(realizationId).then(
          (rows) => rows.map((r) => r.toDomain()).toList(growable: false));

  Stream<List<TaskStateRecord>> watchForRealization(int realizationId) =>
      _database.taskStateDao
          .watchForRealization(realizationId)
          .map((rs) => rs.map((r) => r.toDomain()).toList(growable: false));

  /// Marks the task done and stamps [completedAt], overwriting an earlier
  /// stamp when the task is redone. Any note on the row is kept.
  Future<void> markCompleted(
    int realizationId,
    RecipeTaskId taskId, {
    TaskPayload? payload,
    DateTime? completedAt,
  }) =>
      _upsert(
        realizationId,
        taskId,
        TaskState.completed,
        payload,
        completedAt ?? DateTime.now(),
      );

  Future<void> savePending(
    int realizationId,
    RecipeTaskId taskId, {
    TaskPayload? payload,
  }) =>
      _upsert(realizationId, taskId, TaskState.pending, payload, null);

  /// Saves the free-text note without touching status, payload or the
  /// completion time, so notes can be added to completed tasks later.
  Future<void> saveNotes(
    int realizationId,
    RecipeTaskId taskId,
    String? notes,
  ) =>
      _database.taskStateDao.upsertNotes(
        realizationId,
        taskId,
        notes == null || notes.isEmpty ? null : notes,
      );

  /// Discards the stored data of [taskIds].
  ///
  /// Use when the user jumps back: the caller passes every task that comes
  /// after the target, so the target's own data survives for re-editing.
  Future<void> discard(int realizationId, Iterable<RecipeTaskId> taskIds) =>
      _database.taskStateDao.deleteForIds(realizationId, taskIds);

  Future<void> deleteAllFor(int realizationId) =>
      _database.taskStateDao.deleteAllFor(realizationId);

  Future<void> _upsert(
    int realizationId,
    RecipeTaskId taskId,
    TaskState status,
    TaskPayload? payload,
    DateTime? completedAt,
  ) =>
      _database.taskStateDao.upsert(TaskStateEntityCompanion(
        realizationId: Value(realizationId),
        taskId: Value(taskId),
        status: Value(status),
        payload: Value(payload == null ? null : jsonEncode(payload.toJson())),
        completedAt: Value(completedAt),
      ));
}

@riverpod
TaskStateRepository taskStateRepository(Ref ref) =>
    TaskStateRepository(ref.watch(databaseProvider));

/// Live per-task rows of one realization, keyed by task id.
@riverpod
Stream<Map<RecipeTaskId, TaskStateRecord>> taskStates(
  Ref ref,
  int realizationId,
) =>
    ref
        .watch(taskStateRepositoryProvider)
        .watchForRealization(realizationId)
        .map((rows) => {for (final row in rows) row.taskId: row});

extension _TaskStateEntityDataExtension on TaskStateEntityData {
  TaskStateRecord toDomain() => TaskStateRecord(
        realizationId: realizationId,
        taskId: taskId,
        status: status,
        payloadJson: payload == null
            ? null
            : jsonDecode(payload!) as Map<String, dynamic>,
        notes: notes,
        completedAt: completedAt,
      );
}
