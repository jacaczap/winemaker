import 'package:flutter/material.dart';
import 'package:winemaker/features/realization/presentation/task_notes_field.dart';
import 'package:winemaker/features/realization/presentation/task_timing_summary.dart';
import 'package:winemaker/features/recipe/domain/task.dart';

/// The record-keeping part every task screen ends with: when the task was
/// completed and the user's note.
class TaskFooter extends StatelessWidget {
  const TaskFooter({
    super.key,
    required this.realizationId,
    required this.taskId,
  });

  final int realizationId;
  final RecipeTaskId taskId;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TaskTimingSummary(realizationId: realizationId, taskId: taskId),
          TaskNotesField(realizationId: realizationId, taskId: taskId),
        ],
      );
}
