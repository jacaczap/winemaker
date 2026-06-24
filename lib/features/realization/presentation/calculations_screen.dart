import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winemaker/core/models/alcohol.dart';
import 'package:winemaker/core/models/litres.dart';
import 'package:winemaker/core/models/sugar.dart';
import 'package:winemaker/core/utils/user_input_utils.dart';
import 'package:winemaker/features/calculator/domain/desired_wine.dart';
import 'package:winemaker/features/calculator/domain/ingredients.dart';
import 'package:winemaker/features/calculator/domain/ingredients_calculator.dart';
import 'package:winemaker/features/calculator/domain/must_measurements.dart';
import 'package:winemaker/features/calculator/presentation/calculation_form_fields.dart';
import 'package:winemaker/features/calculator/presentation/ingredients_result_card.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/realization/domain/calculations_payload.dart';
import 'package:winemaker/features/realization/domain/task_screen_result.dart';
import 'package:winemaker/features/realization/presentation/redo_from_here_button.dart';
import 'package:winemaker/l10n/app_localizations.dart';

/// Merged calculations task: desired wine + must measurements + calculated
/// ingredients on a single screen. Persists a [CalculationsPayload] for its
/// task occurrence and pops `true` so the realization advances.
class CalculationsScreen extends ConsumerStatefulWidget {
  const CalculationsScreen({
    super.key,
    required this.realizationId,
    required this.taskIndex,
    required this.title,
    this.readOnly = false,
  });

  final int realizationId;
  final int taskIndex;
  final String title;
  final bool readOnly;

  @override
  ConsumerState<CalculationsScreen> createState() => _CalculationsScreenState();
}

class _CalculationsScreenState extends ConsumerState<CalculationsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool _loading = true;
  bool _saving = false;
  CalculationsPayload? _existing;
  Ingredients? _calculated;

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final record = await ref
        .read(taskStateRepositoryProvider)
        .get(widget.realizationId, widget.taskIndex);
    if (!mounted) return;
    final json = record?.payloadJson;
    setState(() {
      _existing = json == null ? null : CalculationsPayload.fromJson(json);
      _calculated = _existing?.ingredients;
      _loading = false;
    });
  }

  void _calculate() {
    final form = _formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;
    final values = form.value;
    final ingredients = calculateIngredients(
      _readDesiredWine(values),
      _readMust(values),
    );
    setState(() => _calculated = ingredients);
  }

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (_calculated == null || form == null) return;
    setState(() => _saving = true);
    final values = form.value;
    final payload = CalculationsPayload(
      desiredWine: _readDesiredWine(values),
      must: _readMust(values),
      ingredients: _calculated!,
    );
    await ref.read(taskStateRepositoryProvider).markCompleted(
          widget.realizationId,
          widget.taskIndex,
          payload: payload,
        );
    if (!mounted) return;
    context.pop(TaskScreenResult.completed);
  }

  DesiredWine _readDesiredWine(Map<String, dynamic> values) => DesiredWine(
        Alcohol(parseDoubleInput(values[CalculationFields.alcohol] as String)),
        GramsPerLiter(
            parseDoubleInput(values[CalculationFields.sweetness] as String)),
        GramsPerLiter(parseDoubleInput(
            values[CalculationFields.desiredAcidity] as String)),
      );

  MustMeasurements _readMust(Map<String, dynamic> values) => MustMeasurements(
        Litres(parseDoubleInput(values[CalculationFields.volume] as String)),
        Blg(parseDoubleInput(values[CalculationFields.mustSugar] as String)),
        GramsPerLiter(
            parseDoubleInput(values[CalculationFields.mustAcidity] as String)),
      );

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
    final desiredWine = _existing?.desiredWine;
    final must = _existing?.must;
    final readOnly = widget.readOnly;
    return FormBuilder(
      key: _formKey,
      onChanged: () {
        if (_calculated != null) setState(() => _calculated = null);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SectionTitle(l10n.desiredWine),
            DesiredWineFields(
              initialAlcohol: desiredWine?.alcohol.value.toString(),
              initialSweetness: desiredWine?.sugar.value.toString(),
              initialAcidity: desiredWine?.acidity.value.toString(),
              enabled: !readOnly,
            ),
            const SizedBox(height: 24),
            _SectionTitle(l10n.mustMeasurements),
            MustMeasurementFields(
              initialVolume: must?.volume.value.toString(),
              initialSugar: must?.sugar.value.toString(),
              initialAcidity: must?.acidity.value.toString(),
              enabled: !readOnly,
            ),
            const SizedBox(height: 24),
            if (!readOnly)
              OutlinedButton.icon(
                onPressed: _saving ? null : _calculate,
                icon: const Icon(Icons.calculate_outlined),
                label: Text(l10n.calculateIngredients),
              ),
            if (_calculated != null) ...[
              const SizedBox(height: 24),
              IngredientsResultCard(ingredients: _calculated!),
              const SizedBox(height: 16),
            ],
            if (readOnly)
              RedoFromHereButton(
                onPressed: () => context.pop(TaskScreenResult.redo),
              )
            else if (_calculated != null)
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
