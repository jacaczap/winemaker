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
import 'package:winemaker/features/calculator/presentation/ingredients_result_card.dart';
import 'package:winemaker/features/calculator/presentation/setup_form_fields.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/realization/domain/setup_payload.dart';

/// Merged setup task: desired wine + must measurements + calculated ingredients
/// on a single screen. Persists a [SetupPayload] for its task occurrence and
/// pops `true` so the realization advances.
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({
    super.key,
    required this.realizationId,
    required this.taskIndex,
    required this.title,
  });

  final int realizationId;
  final int taskIndex;
  final String title;

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool _loading = true;
  bool _saving = false;
  SetupPayload? _existing;
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
      _existing = json == null ? null : SetupPayload.fromJson(json);
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
    final payload = SetupPayload(
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
    context.pop(true);
  }

  DesiredWine _readDesiredWine(Map<String, dynamic> values) => DesiredWine(
        Alcohol(parseDoubleInput(values[SetupFields.alcohol] as String)),
        GramsPerLiter(parseDoubleInput(values[SetupFields.sweetness] as String)),
        GramsPerLiter(parseDoubleInput(values[SetupFields.desiredAcidity] as String)),
      );

  MustMeasurements _readMust(Map<String, dynamic> values) => MustMeasurements(
        Litres(parseDoubleInput(values[SetupFields.volume] as String)),
        Blg(parseDoubleInput(values[SetupFields.mustSugar] as String)),
        GramsPerLiter(parseDoubleInput(values[SetupFields.mustAcidity] as String)),
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
    final desiredWine = _existing?.desiredWine;
    final must = _existing?.must;
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
            const _SectionTitle('Desired wine'),
            DesiredWineFields(
              initialAlcohol: desiredWine?.alcohol.value.toString(),
              initialSweetness: desiredWine?.sugar.value.toString(),
              initialAcidity: desiredWine?.acidity.value.toString(),
            ),
            const SizedBox(height: 24),
            const _SectionTitle('Must measurements'),
            MustMeasurementFields(
              initialVolume: must?.volume.value.toString(),
              initialSugar: must?.sugar.value.toString(),
              initialAcidity: must?.acidity.value.toString(),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: _saving ? null : _calculate,
              icon: const Icon(Icons.calculate_outlined),
              label: const Text('Calculate ingredients'),
            ),
            if (_calculated != null) ...[
              const SizedBox(height: 24),
              IngredientsResultCard(ingredients: _calculated!),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: const Icon(Icons.check),
                label: const Text('Save & mark done'),
              ),
            ],
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
