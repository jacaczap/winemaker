import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:winemaker/features/calculator/domain/achievable_targets.dart';
import 'package:winemaker/features/calculator/domain/ingredients.dart';
import 'package:winemaker/features/calculator/domain/ingredients_calculator.dart';
import 'package:winemaker/features/calculator/presentation/ingredients_result_card.dart';
import 'package:winemaker/features/calculator/presentation/calculation_form_fields.dart';
import 'package:winemaker/l10n/app_localizations.dart';

/// Standalone ingredients calculator: a what-if tool for computing the
/// ingredients to add from desired wine + must measurements, not bound to any
/// realization. Nothing is persisted.
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Ingredients? _calculated;

  void _calculate() {
    final form = _formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;
    final values = form.value;
    final must = readMust(values);
    if (must == null) return;
    setState(() {
      _calculated = calculateIngredients(readDesiredWine(values), must);
    });
  }

  /// Limits implied by whatever has been measured so far, so the desired-wine
  /// sliders cannot be set to a wine this must cannot make.
  TargetLimits? _limits() {
    final values = _formKey.currentState?.instantValue;
    if (values == null) return null;
    final must = readMust(values);
    if (must == null) return null;
    return targetLimits(must, readDesiredWine(values));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.calculatorTitle)),
      body: SafeArea(
        child: FormBuilder(
          key: _formKey,
          onChanged: () => setState(() => _calculated = null),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SectionTitle(l10n.mustMeasurements),
                const MustMeasurementFields(),
                const SizedBox(height: 24),
                _SectionTitle(l10n.desiredWine),
                DesiredWineFields(limits: _limits()),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: _calculate,
                  icon: const Icon(Icons.calculate_outlined),
                  label: Text(l10n.calculateIngredients),
                ),
                if (_calculated != null) ...[
                  const SizedBox(height: 24),
                  IngredientsResultCard(ingredients: _calculated!),
                ],
              ],
            ),
          ),
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
