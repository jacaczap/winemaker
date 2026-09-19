import 'package:flutter/material.dart';
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
    final lines = journalValueLines(l10n, entry);
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
                for (final line in lines)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      line,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                if (notes.isNotEmpty) _Note(notes: notes),
              ],
            ),
          ),
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

/// What the user entered in a step, as short inline lines.
///
/// Steps that collect nothing (instructions, waiting) return no lines.
List<String> journalValueLines(AppLocalizations l10n, JournalEntry entry) {
  final json = entry.payloadJson;
  if (json == null) return const [];
  switch (entry.task.type) {
    case TaskType.initialMeasurement:
      final payload = InitialMeasurementPayload.fromJson(json);
      return ['${l10n.journalSweetness} ${_number(payload.sweetness.value)} Blg'];
    case TaskType.calculations:
      return _calculationLines(l10n, CalculationsPayload.fromJson(json));
    case TaskType.addingIngredients:
      final added = AddingIngredientsPayload.fromJson(json).added;
      final parts = [
        if (added.sugar.value > 0)
          '${l10n.ingredientSugar} ${_number(added.sugar.value)} kg',
        if (added.water.value > 0)
          '${l10n.ingredientWater} ${_number(added.water.value)} l',
        if (added.yeast) l10n.ingredientYeast,
        if (added.nutrients) l10n.ingredientNutrients,
      ];
      return parts.isEmpty ? const [] : [parts.join('  ·  ')];
    case TaskType.result:
      final payload = ResultPayload.fromJson(json);
      return [
        if (payload.results.trim().isNotEmpty)
          '${l10n.resultsLabel}: ${payload.results.trim()}',
        if (payload.mistakes.trim().isNotEmpty)
          '${l10n.mistakesLabel}: ${payload.mistakes.trim()}',
      ];
    case TaskType.description:
    case TaskType.timeNotification:
      return const [];
  }
}

List<String> _calculationLines(
  AppLocalizations l10n,
  CalculationsPayload payload,
) {
  final must = payload.must;
  final desired = payload.desiredWine;
  final ingredients = payload.ingredients;
  return [
    '${l10n.journalMust}: ${l10n.journalVolume} ${_number(must.volume.value)} l'
        '  ·  ${l10n.journalSweetness} ${_number(must.sugar.value)} Blg'
        '  ·  ${l10n.journalAcidity} ${_number(must.acidity.value)} g/l',
    '${l10n.journalTarget}: ${l10n.journalAlcohol} '
        '${_number(desired.alcohol.value)} %'
        '  ·  ${l10n.journalSweetness} ${_number(desired.sugar.value)} g/l'
        '  ·  ${l10n.journalAcidity} ${_number(desired.acidity.value)} g/l',
    '${l10n.journalCalculated}: ${l10n.ingredientSugar} '
        '${_number(ingredients.sugar.value)} kg'
        '  ·  ${l10n.ingredientWater} ${_number(ingredients.water.value)} l',
  ];
}

String _number(double value) =>
    value == value.roundToDouble() ? value.toStringAsFixed(0) : '$value';
