import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:winemaker/core/models/alcohol.dart';
import 'package:winemaker/core/models/litres.dart';
import 'package:winemaker/core/models/sugar.dart';
import 'package:winemaker/core/utils/user_input_utils.dart';
import 'package:winemaker/features/calculator/domain/desired_wine.dart';
import 'package:winemaker/features/calculator/domain/ingredients.dart';
import 'package:winemaker/features/calculator/domain/ingredients_calculator.dart';
import 'package:winemaker/features/calculator/domain/must_measurements.dart';
import 'package:winemaker/features/calculator/presentation/ingredients_result_card.dart';
import 'package:winemaker/features/calculator/presentation/calculation_form_fields.dart';

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
    setState(() {
      _calculated = calculateIngredients(
        _readDesiredWine(values),
        _readMust(values),
      );
    });
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
      appBar: AppBar(title: const Text('Calculator')),
      body: SafeArea(
        child: FormBuilder(
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
                const DesiredWineFields(),
                const SizedBox(height: 24),
                const _SectionTitle('Must measurements'),
                const MustMeasurementFields(),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: _calculate,
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text('Calculate ingredients'),
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
