import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winemaker/core/models/litres.dart';
import 'package:winemaker/core/models/sugar.dart';
import 'package:winemaker/core/utils/math_utils.dart';
import 'package:winemaker/core/utils/user_input_utils.dart';
import 'package:winemaker/core/widgets/form_builder.dart';
import 'package:winemaker/features/calculator/domain/ingredients.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/realization/domain/adding_ingredients_payload.dart';
import 'package:winemaker/features/realization/domain/calculations_payload.dart';
import 'package:winemaker/features/realization/domain/task_screen_result.dart';
import 'package:winemaker/features/realization/presentation/redo_from_here_button.dart';
import 'package:winemaker/features/recipe/domain/task.dart';
import 'package:winemaker/l10n/app_localizations.dart';

/// Adding-ingredients task: shows what is still left to add (the calculated
/// total minus prior portions) and records what the user adds in this
/// occurrence.
///
/// [ingredients] decides what the step asks about, so the same screen serves
/// both the yeast-and-nutrients step before fermentation and the sugar steps
/// after pressing. Amounts recorded by an earlier version of the recipe are
/// still shown, read-only, so nothing entered before disappears.
class AddingIngredientsScreen extends ConsumerStatefulWidget {
  const AddingIngredientsScreen({
    super.key,
    required this.realizationId,
    required this.taskId,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.calculationsTaskId,
    required this.priorIngredientTaskIds,
    this.readOnly = false,
  });

  final int realizationId;
  final RecipeTaskId taskId;
  final String title;
  final String description;
  final Set<IngredientKind> ingredients;
  final RecipeTaskId? calculationsTaskId;
  final List<RecipeTaskId> priorIngredientTaskIds;
  final bool readOnly;

  @override
  ConsumerState<AddingIngredientsScreen> createState() =>
      _AddingIngredientsScreenState();
}

class _AddingIngredientsScreenState
    extends ConsumerState<AddingIngredientsScreen> {
  static const _sugarField = 'addedSugar';
  static const _waterField = 'addedWater';

  final _formKey = GlobalKey<FormBuilderState>();

  bool _loading = true;
  bool _saving = false;
  AddingIngredientsPayload? _existing;
  _Remaining _remaining = const _Remaining();
  Set<IngredientKind> _visible = const {};
  bool _yeastAdded = false;
  bool _nutrientsAdded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repository = ref.read(taskStateRepositoryProvider);

    Ingredients? total;
    final calculationsTaskId = widget.calculationsTaskId;
    if (calculationsTaskId != null) {
      final json = (await repository.get(
        widget.realizationId,
        calculationsTaskId,
      ))?.payloadJson;
      if (json != null) total = CalculationsPayload.fromJson(json).ingredients;
    }

    var priorSugar = 0.0;
    var priorWater = 0.0;
    var priorYeast = false;
    var priorNutrients = false;
    for (final taskId in widget.priorIngredientTaskIds) {
      final json =
          (await repository.get(widget.realizationId, taskId))?.payloadJson;
      if (json == null) continue;
      final added = AddingIngredientsPayload.fromJson(json).added;
      priorSugar += added.sugar.value;
      priorWater += added.water.value;
      priorYeast = priorYeast || added.yeast;
      priorNutrients = priorNutrients || added.nutrients;
    }

    final existingJson =
        (await repository.get(widget.realizationId, widget.taskId))
            ?.payloadJson;
    final existing = existingJson == null
        ? null
        : AddingIngredientsPayload.fromJson(existingJson);

    if (!mounted) return;
    setState(() {
      _existing = existing;
      _visible = _visibleIngredients(existing);
      _remaining = _Remaining(
        sugar: max(0.0, (total?.sugar.value ?? 0) - priorSugar).roundTo(2),
        water: max(0.0, (total?.water.value ?? 0) - priorWater).roundTo(2),
        yeast: widget.ingredients.contains(IngredientKind.yeast) && !priorYeast,
        nutrients: widget.ingredients.contains(IngredientKind.nutrients) &&
            !priorNutrients,
      );
      _yeastAdded =
          existing?.added.yeast ?? _defaultChecked(IngredientKind.yeast);
      _nutrientsAdded = existing?.added.nutrients ??
          _defaultChecked(IngredientKind.nutrients);
      _loading = false;
    });
  }

  /// What this step asks about, plus anything a previous version of the recipe
  /// recorded here so old values stay visible.
  Set<IngredientKind> _visibleIngredients(AddingIngredientsPayload? existing) {
    final visible = {...widget.ingredients};
    final added = existing?.added;
    if (added == null) return visible;
    if (added.sugar.value > 0) visible.add(IngredientKind.sugar);
    if (added.water.value > 0) visible.add(IngredientKind.water);
    if (added.yeast) visible.add(IngredientKind.yeast);
    if (added.nutrients) visible.add(IngredientKind.nutrients);
    return visible;
  }

  bool _defaultChecked(IngredientKind kind) =>
      widget.ingredients.contains(kind) && !widget.readOnly;

  bool _isEditable(IngredientKind kind) =>
      !widget.readOnly && widget.ingredients.contains(kind);

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;
    setState(() => _saving = true);
    final values = form.value;
    final previous = _existing?.added;
    final payload = AddingIngredientsPayload(
      added: Ingredients(
        Kilograms(_isEditable(IngredientKind.sugar)
            ? parseDoubleInputOrZero(values[_sugarField] as String?)
            : previous?.sugar.value ?? 0),
        Litres(_isEditable(IngredientKind.water)
            ? parseDoubleInputOrZero(values[_waterField] as String?)
            : previous?.water.value ?? 0),
        _yeastAdded,
        _nutrientsAdded,
      ),
    );
    await ref.read(taskStateRepositoryProvider).markCompleted(
          widget.realizationId,
          widget.taskId,
          payload: payload,
        );
    if (!mounted) return;
    context.pop(TaskScreenResult.completed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(child: _buildForm(context)),
    );
  }

  Widget _buildForm(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final readOnly = widget.readOnly;
    final endsWithCheckbox = _visible.contains(IngredientKind.yeast) ||
        _visible.contains(IngredientKind.nutrients);
    return FormBuilder(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.description.isNotEmpty) ...[
              Text(
                widget.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
            ],
            _RemainingCard(remaining: _remaining, visible: _visible),
            const SizedBox(height: 24),
            Text(
              l10n.addedThisStep,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (_visible.contains(IngredientKind.sugar)) ...[
              buildNumberField(
                l10n: l10n,
                name: _sugarField,
                label: l10n.addedSugar,
                suffix: 'kg',
                initialValue: _existing?.added.sugar.value.toString(),
                enabled: _isEditable(IngredientKind.sugar),
                optional: true,
              ),
              const SizedBox(height: 12),
            ],
            if (_visible.contains(IngredientKind.water)) ...[
              buildNumberField(
                l10n: l10n,
                name: _waterField,
                label: l10n.addedWater,
                suffix: 'l',
                initialValue: _existing?.added.water.value.toString(),
                enabled: _isEditable(IngredientKind.water),
                optional: true,
              ),
              const SizedBox(height: 12),
            ],
            if (_visible.contains(IngredientKind.yeast))
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.yeastAdded),
                value: _yeastAdded,
                onChanged: _isEditable(IngredientKind.yeast)
                    ? (v) => setState(() => _yeastAdded = v!)
                    : null,
              ),
            if (_visible.contains(IngredientKind.nutrients))
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.nutrientsAdded),
                value: _nutrientsAdded,
                onChanged: _isEditable(IngredientKind.nutrients)
                    ? (v) => setState(() => _nutrientsAdded = v!)
                    : null,
              ),
            SizedBox(height: endsWithCheckbox ? 24 : 12),
            if (readOnly)
              RedoFromHereButton(
                onPressed: () => context.pop(TaskScreenResult.redo),
              )
            else
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: const Icon(Icons.check),
                label: Text(l10n.saveAndMarkDone),
              ),
          ],
        ),
      ),
    );
  }
}

/// Remaining-to-add amounts before this occurrence: the calculated total minus
/// prior portions.
class _Remaining {
  const _Remaining({
    this.sugar = 0,
    this.water = 0,
    this.yeast = false,
    this.nutrients = false,
  });

  final double sugar;
  final double water;
  final bool yeast;
  final bool nutrients;
}

class _RemainingCard extends StatelessWidget {
  const _RemainingCard({required this.remaining, required this.visible});

  final _Remaining remaining;
  final Set<IngredientKind> visible;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.remainingToAdd, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            if (visible.contains(IngredientKind.sugar))
              _RemainingRow(
                icon: Icons.scale_outlined,
                label: l10n.ingredientSugar,
                value: '${remaining.sugar} kg',
              ),
            if (visible.contains(IngredientKind.water))
              _RemainingRow(
                icon: Icons.water_drop_outlined,
                label: l10n.ingredientWater,
                value: '${remaining.water} l',
              ),
            if (visible.contains(IngredientKind.yeast))
              _RemainingRow(
                icon: Icons.science_outlined,
                label: l10n.ingredientYeast,
                value: remaining.yeast ? l10n.valueAdd : l10n.valueDone,
              ),
            if (visible.contains(IngredientKind.nutrients))
              _RemainingRow(
                icon: Icons.eco_outlined,
                label: l10n.ingredientNutrients,
                value: remaining.nutrients ? l10n.valueAdd : l10n.valueDone,
              ),
          ],
        ),
      ),
    );
  }
}

class _RemainingRow extends StatelessWidget {
  const _RemainingRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
          Text(
            value,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
