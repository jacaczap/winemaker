import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:winemaker/core/utils/duration_format.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/realization/domain/task_timing.dart';
import 'package:winemaker/features/realization/presentation/recipe_realization_controller.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/features/recipe/domain/task.dart';
import 'package:winemaker/l10n/app_localizations.dart';

/// When a completed task was finished and how long it took.
///
/// Shows nothing while the task is unfinished, or for realizations older than
/// timestamp tracking.
class TaskTimingSummary extends ConsumerWidget {
  const TaskTimingSummary({
    super.key,
    required this.realizationId,
    required this.taskId,
  });

  final int realizationId;
  final RecipeTaskId taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final realization =
        ref.watch(recipeRealizationControllerProvider(realizationId)).value;
    final states = ref.watch(taskStatesProvider(realizationId)).value;
    if (realization == null || states == null) return const SizedBox.shrink();

    final timing = taskTimingOf(
      tasks: realization.recipe.getRecipe().tasks,
      states: states,
      taskId: taskId,
      realizationStart: realization.startTime,
    );
    final completedAt = timing.completedAt;
    if (completedAt == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            Icons.history_outlined,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              formatCompletion(l10n, timing),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Completed 3 Mar 2026 - took 5 days", or just the date when the length of
/// the step cannot be worked out.
String formatCompletion(
  AppLocalizations l10n,
  TaskTiming timing, {
  bool withTime = true,
}) {
  final pattern = withTime ? 'd MMM yyyy, HH:mm' : 'd MMM yyyy';
  final date = DateFormat(pattern, l10n.localeName).format(timing.completedAt!);
  final duration = timing.duration;
  return duration == null
      ? l10n.completedOn(date)
      : l10n.completedOnTook(date, formatElapsed(l10n, duration));
}
