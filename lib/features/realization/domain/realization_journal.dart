import 'package:winemaker/features/realization/domain/task_state.dart';
import 'package:winemaker/features/recipe/domain/task.dart';

/// One finished step as it appears in the journal.
class JournalEntry {
  const JournalEntry({
    required this.task,
    this.completedAt,
    this.notes,
    this.payloadJson,
  });

  final Task task;
  final DateTime? completedAt;
  final String? notes;
  final Map<String, dynamic>? payloadJson;
}

/// Steps finished on the same calendar day.
///
/// [date] is null for steps with no recorded completion time (realizations
/// made before timestamps were tracked); those never carry a gap.
class JournalDay {
  const JournalDay({
    required this.date,
    required this.entries,
    this.daysSincePrevious,
  });

  final DateTime? date;
  final List<JournalEntry> entries;

  /// Whole days between this day and the previous dated one.
  final int? daysSincePrevious;
}

/// Groups the finished steps of a realization into journal days.
///
/// Only the first [completedTaskCount] tasks are included, so an unfinished
/// realization shows what is done and nothing else.
List<JournalDay> buildJournal({
  required List<Task> tasks,
  required Map<RecipeTaskId, TaskStateRecord> states,
  required int completedTaskCount,
}) {
  final days = <JournalDay>[];
  var entries = <JournalEntry>[];
  DateTime? currentDate;
  DateTime? previousDate;

  void flush() {
    if (entries.isEmpty) return;
    final date = currentDate;
    final previous = previousDate;
    days.add(JournalDay(
      date: date,
      entries: entries,
      daysSincePrevious: date == null || previous == null
          ? null
          : date.difference(previous).inDays,
    ));
    if (date != null) previousDate = date;
    entries = <JournalEntry>[];
  }

  for (final task in tasks.take(completedTaskCount)) {
    final state = states[task.id];
    final date = _dayOf(state?.completedAt);
    if (entries.isNotEmpty && date != currentDate) flush();
    currentDate = date;
    entries.add(JournalEntry(
      task: task,
      completedAt: state?.completedAt,
      notes: state?.notes,
      payloadJson: state?.payloadJson,
    ));
  }
  flush();
  return days;
}

DateTime? _dayOf(DateTime? time) =>
    time == null ? null : DateTime(time.year, time.month, time.day);
