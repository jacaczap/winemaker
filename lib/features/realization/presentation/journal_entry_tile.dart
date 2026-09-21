import 'package:flutter/material.dart';
import 'package:winemaker/core/utils/number_format.dart';
import 'package:winemaker/features/realization/domain/adding_ingredients_payload.dart';
import 'package:winemaker/features/realization/domain/calculations_payload.dart';
import 'package:winemaker/features/realization/domain/initial_measurement_payload.dart';
import 'package:winemaker/features/realization/domain/realization_journal.dart';
import 'package:winemaker/features/realization/domain/result_payload.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/features/recipe/domain/task_type.dart';
import 'package:winemaker/l10n/app_localizations.dart';

/// One step in the journal: its name, what the user entered and their note.
class JournalEntryTile extends StatelessWidget {
  const JournalEntryTile({super.key, required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final groups = journalValueGroups(l10n, entry);
    final notes = entry.notes?.trim() ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              entry.task.type.icon,
              size: 20,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.task.id.displayName(l10n),
                  style: theme.textTheme.titleMedium,
                ),
                for (final group in groups) _Group(group: group),
                if (notes.isNotEmpty) _Note(notes: notes),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.group});

  final JournalValueGroup group;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = group.title;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title,
              style: theme.textTheme.labelLarge
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          for (final row in group.rows) _Row(row: row),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.row});

  final JournalValueRow row;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium
        ?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final value = row.value;
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: value == null
          ? Text(row.label, style: style)
          : Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(child: Text(row.label, style: style)),
                const SizedBox(width: 12),
                Text(value, style: style?.copyWith(color: theme.colorScheme.onSurface)),
              ],
            ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: theme.colorScheme.outlineVariant, width: 2),
        ),
      ),
      child: Text(
        notes,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontStyle: FontStyle.italic,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// A block of recorded values, optionally under a heading.
class JournalValueGroup {
  const JournalValueGroup({required this.rows, this.title});

  final String? title;
  final List<JournalValueRow> rows;
}

/// One recorded value. [value] is null for free text that has nothing to
/// align against, such as the notes written in the result step.
class JournalValueRow {
  const JournalValueRow(this.label, [this.value]);

  final String label;
  final String? value;
}

/// What the user entered in a step.
///
/// Steps that collect nothing (instructions, waiting) return no groups.
List<JournalValueGroup> journalValueGroups(
  AppLocalizations l10n,
  JournalEntry entry,
) {
  final json = entry.payloadJson;
  if (json == null) return const [];
  switch (entry.task.type) {
    case TaskType.initialMeasurement:
      final payload = InitialMeasurementPayload.fromJson(json);
      return [
        JournalValueGroup(rows: [
          JournalValueRow(
            l10n.journalSugar,
            '${formatAmount(payload.sweetness.value)} Blg',
          ),
        ]),
      ];
    case TaskType.calculations:
      return _calculationGroups(l10n, CalculationsPayload.fromJson(json));
    case TaskType.addingIngredients:
      final added = AddingIngredientsPayload.fromJson(json).added;
      final rows = [
        if (added.sugar.value > 0)
          JournalValueRow(
            l10n.ingredientSugar,
            '${formatAmount(added.sugar.value)} kg',
          ),
        if (added.water.value > 0)
          JournalValueRow(
            l10n.ingredientWater,
            '${formatAmount(added.water.value)} l',
          ),
        if (added.yeast) JournalValueRow(l10n.ingredientYeast, l10n.valueDone),
        if (added.nutrients)
          JournalValueRow(l10n.ingredientNutrients, l10n.valueDone),
      ];
      return rows.isEmpty ? const [] : [JournalValueGroup(rows: rows)];
    case TaskType.result:
      final payload = ResultPayload.fromJson(json);
      final results = payload.results.trim();
      final mistakes = payload.mistakes.trim();
      return [
        if (results.isNotEmpty)
          JournalValueGroup(
            title: l10n.resultsLabel,
            rows: [JournalValueRow(results)],
          ),
        if (mistakes.isNotEmpty)
          JournalValueGroup(
            title: l10n.mistakesLabel,
            rows: [JournalValueRow(mistakes)],
          ),
      ];
    case TaskType.description:
    case TaskType.timeNotification:
      return const [];
  }
}

List<JournalValueGroup> _calculationGroups(
  AppLocalizations l10n,
  CalculationsPayload payload,
) {
  final must = payload.must;
  final desired = payload.desiredWine;
  final ingredients = payload.ingredients;
  return [
    JournalValueGroup(title: l10n.journalMust, rows: [
      JournalValueRow(
          l10n.journalVolume, '${formatAmount(must.volume.value)} l'),
      JournalValueRow(
          l10n.journalSugar, '${formatAmount(must.sugar.value)} Blg'),
      JournalValueRow(
          l10n.journalAcidity, '${formatAmount(must.acidity.value)} g/l'),
    ]),
    JournalValueGroup(title: l10n.journalTarget, rows: [
      JournalValueRow(
          l10n.journalAlcohol, '${formatAmount(desired.alcohol.value)} %'),
      JournalValueRow(
          l10n.journalSweetness, '${formatAmount(desired.sugar.value)} g/l'),
      JournalValueRow(
          l10n.journalAcidity, '${formatAmount(desired.acidity.value)} g/l'),
    ]),
    JournalValueGroup(title: l10n.journalCalculated, rows: [
      JournalValueRow(
          l10n.ingredientSugar, '${formatAmount(ingredients.sugar.value)} kg'),
      JournalValueRow(
          l10n.ingredientWater, '${formatAmount(ingredients.water.value)} l'),
    ]),
  ];
}
