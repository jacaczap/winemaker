/// Outcome a task screen pops back to the realization view.
enum TaskScreenResult {
  /// The task was performed or confirmed; advance the realization.
  completed,

  /// The user chose to redo from this (completed) task; the realization should
  /// jump back to it, discarding the data of all later tasks.
  redo,
}
