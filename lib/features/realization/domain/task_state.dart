/// Status of a single task occurrence within a realization.
///
/// Persisted as text so adding values later does not require a migration.
enum TaskState {
  pending,
  completed,
}

/// Payload that a task occurrence can serialize into its row.
///
/// Each task type owning per-task data implements this in its feature layer
/// (e.g. `DesiredWinePayload`, `MustPayload`, `IngredientsPayload`,
/// `SetupPayload`, `ResultPayload`). The repository encodes
/// `toJson()` as a JSON string in the `payload` column.
abstract class TaskPayload {
  const TaskPayload();

  Map<String, dynamic> toJson();
}

/// A single row in `realization_task_state`.
///
/// `payloadJson` is the decoded JSON map (or null if the row stores no data,
/// e.g. a description task that's merely acknowledged). Callers decode it
/// into their typed payload using the task-type's `fromJson` constructor.
class TaskStateRecord {
  const TaskStateRecord({
    required this.realizationId,
    required this.taskIndex,
    required this.status,
    required this.payloadJson,
  });

  final int realizationId;
  final int taskIndex;
  final TaskState status;
  final Map<String, dynamic>? payloadJson;
}
