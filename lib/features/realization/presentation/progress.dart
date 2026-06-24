import 'package:flutter/material.dart';
import 'package:winemaker/l10n/app_localizations.dart';

class RecipeProgressHeader extends StatelessWidget {
  const RecipeProgressHeader({
    super.key,
    required this.totalNumberOfTasks,
    required this.numberOfCompletedTasks,
  });

  final int totalNumberOfTasks;
  final int numberOfCompletedTasks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isEmpty = totalNumberOfTasks == 0;
    final completed = numberOfCompletedTasks.clamp(0, totalNumberOfTasks);
    final progress = isEmpty ? 0.0 : completed / totalNumberOfTasks;
    final isFinished = !isEmpty && completed >= totalNumberOfTasks;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isFinished ? l10n.allTasksComplete : l10n.progress,
                style: theme.textTheme.titleMedium,
              ),
              Text(
                '$completed / $totalNumberOfTasks',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Semantics(
            label: l10n.semanticsRecipeProgress,
            value: l10n.semanticsTasksCompleted(completed, totalNumberOfTasks),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
