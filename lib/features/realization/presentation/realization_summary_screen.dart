import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:winemaker/app/router.dart';
import 'package:winemaker/core/utils/duration_format.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/realization/domain/realization_journal.dart';
import 'package:winemaker/features/realization/domain/recipe_realization.dart';
import 'package:winemaker/features/realization/presentation/journal_entry_tile.dart';
import 'package:winemaker/features/realization/presentation/recipe_realization_controller.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/l10n/app_localizations.dart';

/// Journal of a realization: what was done, when, and what was written down.
///
/// This is where a completed realization opens; editing it means going back to
/// the step list.
class RealizationSummaryScreen extends ConsumerWidget {
  const RealizationSummaryScreen({super.key, required this.realizationId});

  final int realizationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final realization =
        ref.watch(recipeRealizationControllerProvider(realizationId));
    final states = ref.watch(taskStatesProvider(realizationId));
    final l10n = AppLocalizations.of(context);
    final data = realization.value;

    return Scaffold(
      appBar: AppBar(title: Text(data?.displayName(l10n) ?? l10n.summaryTitle)),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.editRealization,
        onPressed: () => context.pushNamed(
          AppRoute.recipe,
          pathParameters: {AppRoute.realizationIdParam: '$realizationId'},
        ),
        child: const Icon(Icons.edit),
      ),
      body: realization.when(
        data: (realization) => states.when(
          data: (states) => _Journal(
            realization: realization,
            days: buildJournal(
              tasks: realization.recipe.getRecipe().tasks,
              states: states,
              completedTaskCount: realization.currentTask,
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(l10n.errorWithMessage(error))),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(l10n.errorWithMessage(error))),
      ),
    );
  }
}

class _Journal extends StatelessWidget {
  const _Journal({required this.realization, required this.days});

  final RecipeRealization realization;
  final List<JournalDay> days;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (days.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(l10n.summaryEmpty, textAlign: TextAlign.center),
        ),
      );
    }
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          _Header(realization: realization, days: days),
          for (final day in days) ..._daySection(day, first: day == days.first),
        ],
      ),
    );
  }

  List<Widget> _daySection(JournalDay day, {required bool first}) {
    final gap = day.daysSincePrevious ?? 0;
    return [
      if (gap > 0)
        _GapSeparator(days: gap)
      else if (!first)
        const SizedBox(height: 16),
      if (day.date != null) _DayHeader(date: day.date!),
      for (final entry in day.entries) JournalEntryTile(entry: entry),
    ];
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.realization, required this.days});

  final RecipeRealization realization;
  final List<JournalDay> days;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final finishedAt = days.last.entries.last.completedAt;
    final total = finishedAt?.difference(realization.startTime);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              realization.recipe.displayName(l10n),
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.journalStarted(_formatDate(l10n, realization.startTime)),
              style: theme.textTheme.bodyMedium,
            ),
            if (finishedAt != null && realization.completed)
              Text(
                l10n.journalFinished(_formatDate(l10n, finishedAt)),
                style: theme.textTheme.bodyMedium,
              ),
            if (total != null && !total.isNegative)
              Text(
                l10n.journalTook(formatElapsed(l10n, total)),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 2),
      child: Text(
        _formatDate(AppLocalizations.of(context), date),
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _GapSeparator extends StatelessWidget {
  const _GapSeparator({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              AppLocalizations.of(context).durationDays(days),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

String _formatDate(AppLocalizations l10n, DateTime date) =>
    DateFormat('d MMM yyyy', l10n.localeName).format(date);
