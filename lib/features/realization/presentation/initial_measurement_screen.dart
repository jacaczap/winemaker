import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winemaker/core/models/sugar.dart';
import 'package:winemaker/core/utils/user_input_utils.dart';
import 'package:winemaker/core/widgets/slider_number_field.dart';
import 'package:winemaker/features/calculator/domain/field_presets.dart';
import 'package:winemaker/features/calculator/domain/field_ranges.dart';
import 'package:winemaker/features/calculator/presentation/calculation_form_fields.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/realization/domain/initial_measurement_payload.dart';
import 'package:winemaker/features/realization/domain/task_screen_result.dart';
import 'package:winemaker/features/realization/presentation/redo_from_here_button.dart';
import 'package:winemaker/features/recipe/domain/task.dart';
import 'package:winemaker/l10n/app_localizations.dart';

/// Initial-measurement task: records the must sweetness before fermentation.
///
/// Deliberately does not calculate anything. The volume and acidity that the
/// calculation needs are only measurable after pressing, so this task captures
/// the single reading that fermentation would destroy and nothing else.
class InitialMeasurementScreen extends ConsumerStatefulWidget {
  const InitialMeasurementScreen({
    super.key,
    required this.realizationId,
    required this.taskId,
    required this.title,
    required this.description,
    this.readOnly = false,
  });

  final int realizationId;
  final RecipeTaskId taskId;
  final String title;
  final String description;
  final bool readOnly;

  @override
  ConsumerState<InitialMeasurementScreen> createState() =>
      _InitialMeasurementScreenState();
}

class _InitialMeasurementScreenState
    extends ConsumerState<InitialMeasurementScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool _loading = true;
  bool _saving = false;
  InitialMeasurementPayload? _existing;

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final record = await ref
        .read(taskStateRepositoryProvider)
        .get(widget.realizationId, widget.taskId);
    if (!mounted) return;
    final json = record?.payloadJson;
    setState(() {
      _existing =
          json == null ? null : InitialMeasurementPayload.fromJson(json);
      _loading = false;
    });
  }

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;
    setState(() => _saving = true);
    final sweetness = parseDoubleInput(
      form.value[CalculationFields.mustSugar] as String,
    );
    await ref.read(taskStateRepositoryProvider).markCompleted(
          widget.realizationId,
          widget.taskId,
          payload: InitialMeasurementPayload(sweetness: Blg(sweetness)),
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
            SliderNumberField(
              name: CalculationFields.mustSugar,
              label: l10n.fieldMustSugar,
              suffix: 'Blg',
              range: FieldRanges.mustSweetness,
              initialValue: _existing?.sweetness.value.toString(),
              enabled: !widget.readOnly,
              presets: FieldPresets.measuredSweetness(l10n),
            ),
            const SizedBox(height: 24),
            if (widget.readOnly)
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
