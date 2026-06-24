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

/// Adding-ingredients task: shows what is still left to add (the calculated
/// total minus prior portions) and records what the user adds in this
/// occurrence.
///
/// The total comes from the preceding `calculations` task; prior
/// `addingIngredients` occurrences are summed so a split ingredient (e.g.
/// sugar) tracks remaining across repeats. Persists an
/// [AddingIngredientsPayload] and pops `true` so the realization advances.
class AddingIngredientsScreen extends ConsumerStatefulWidget {
  const AddingIngredientsScreen({
    super.key,
    required this.realizationId,
    required this.taskIndex,
    required this.title,
    required this.description,
    required this.calculationsTaskIndex,
    required this.priorIngredientTaskIndices,
    this.readOnly = false,
  });

  final int realizationId;
  final int taskIndex;
  final String title;
  final String description;
  final int? calculationsTaskIndex;
  final List<int> priorIngredientTaskIndices;
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
  bool _yeastAdded = false;
  bool _nutrientsAdded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(taskStateRepositoryProvider);

    Ingredients? total;
    final calculationsIndex = widget.calculationsTaskIndex;
    if (calculationsIndex != null) {
      final json =
          (await repo.get(widget.realizationId, calculationsIndex))?.payloadJson;
      if (json != null) total = CalculationsPayload.fromJson(json).ingredients;
    }

    var priorSugar = 0.0;
    var priorWater = 0.0;
    var priorYeast = false;
    var priorNutrients = false;
    for (final index in widget.priorIngredientTaskIndices) {
      final json = (await repo.get(widget.realizationId, index))?.payloadJson;
      if (json == null) continue;
      final added = AddingIngredientsPayload.fromJson(json).added;
      priorSugar += added.sugar.value;
      priorWater += added.water.value;
      priorYeast = priorYeast || added.yeast;
      priorNutrients = priorNutrients || added.nutrients;
    }

    final existingJson =
        (await repo.get(widget.realizationId, widget.taskIndex))?.payloadJson;

    if (!mounted) return;
    setState(() {
      _existing = existingJson == null
          ? null
          : AddingIngredientsPayload.fromJson(existingJson);
      _remaining = _Remaining(
        sugar: max(0.0, (total?.sugar.value ?? 0) - priorSugar).roundTo(2),
        water: max(0.0, (total?.water.value ?? 0) - priorWater).roundTo(2),
        yeast: (total?.yeast ?? false) && !priorYeast,
        nutrients: (total?.nutrients ?? false) && !priorNutrients,
      );
      _yeastAdded = _existing?.added.yeast ?? false;
      _nutrientsAdded = _existing?.added.nutrients ?? false;
      _loading = false;
    });
  }

  bool get _showYeast => _remaining.yeast || (_existing?.added.yeast ?? false);
  bool get _showNutrients =>
      _remaining.nutrients || (_existing?.added.nutrients ?? false);

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;
    setState(() => _saving = true);
    final values = form.value;
    final payload = AddingIngredientsPayload(
      added: Ingredients(
        Kilograms(parseDoubleInputOrZero(values[_sugarField] as String?)),
        Litres(parseDoubleInputOrZero(values[_waterField] as String?)),
        _yeastAdded,
        _nutrientsAdded,
      ),
    );
    await ref.read(taskStateRepositoryProvider).markCompleted(
          widget.realizationId,
          widget.taskIndex,
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
    final readOnly = widget.readOnly;
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
            _RemainingCard(remaining: _remaining),
            const SizedBox(height: 24),
            Text(
              'Added this step',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            buildNumberField(
              name: _sugarField,
              label: 'Added sugar',
              suffix: 'kg',
              initialValue: _existing?.added.sugar.value.toString(),
              enabled: !readOnly,
              optional: true,
            ),
            const SizedBox(height: 12),
            buildNumberField(
              name: _waterField,
              label: 'Added water',
              suffix: 'l',
              initialValue: _existing?.added.water.value.toString(),
              enabled: !readOnly,
              optional: true,
            ),
            if (_showYeast)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Yeast added'),
                value: _yeastAdded,
                onChanged:
                    readOnly ? null : (v) => setState(() => _yeastAdded = v!),
              ),
            if (_showNutrients)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Nutrients added'),
                value: _nutrientsAdded,
                onChanged: readOnly
                    ? null
                    : (v) => setState(() => _nutrientsAdded = v!),
              ),
            const SizedBox(height: 24),
            if (readOnly)
              RedoFromHereButton(
                onPressed: () => context.pop(TaskScreenResult.redo),
              )
            else
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: const Icon(Icons.check),
                label: const Text('Save & mark done'),
              ),
          ],
        ),
      ),
    );
  }
}

/// Remaining-to-add amounts before this occurrence (total minus prior portions).
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
  const _RemainingCard({required this.remaining});

  final _Remaining remaining;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Remaining to add', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            _RemainingRow(
              icon: Icons.scale_outlined,
              label: 'Sugar',
              value: '${remaining.sugar} kg',
            ),
            _RemainingRow(
              icon: Icons.water_drop_outlined,
              label: 'Water',
              value: '${remaining.water} l',
            ),
            _RemainingRow(
              icon: Icons.science_outlined,
              label: 'Yeast',
              value: remaining.yeast ? 'Add' : 'Done',
            ),
            _RemainingRow(
              icon: Icons.eco_outlined,
              label: 'Nutrients',
              value: remaining.nutrients ? 'Add' : 'Done',
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
