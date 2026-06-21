import 'package:flutter/material.dart';
import 'package:winemaker/core/widgets/form_builder.dart';
import 'package:winemaker/features/calculator/domain/field_presets.dart';

/// Field names shared by the calculations screen and the standalone calculator
/// so both read the same values out of the enclosing `FormBuilder`.
class CalculationFields {
  static const alcohol = 'alcohol';
  static const sweetness = 'sweetness';
  static const desiredAcidity = 'desiredAcidity';
  static const volume = 'volume';
  static const mustSugar = 'mustSugar';
  static const mustAcidity = 'mustAcidity';
}

/// Inputs describing the wine the user wants to make.
class DesiredWineFields extends StatelessWidget {
  const DesiredWineFields({
    super.key,
    this.initialAlcohol,
    this.initialSweetness,
    this.initialAcidity,
    this.enabled = true,
  });

  final String? initialAlcohol;
  final String? initialSweetness;
  final String? initialAcidity;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildNumberField(
          name: CalculationFields.alcohol,
          label: 'Desired alcohol',
          suffix: '%',
          initialValue: initialAlcohol,
          enabled: enabled,
          presets: FieldPresets.desiredAlcohol,
        ),
        const SizedBox(height: 12),
        buildNumberField(
          name: CalculationFields.sweetness,
          label: 'Desired sweetness',
          suffix: 'g/l',
          initialValue: initialSweetness,
          enabled: enabled,
          presets: FieldPresets.desiredSweetness,
        ),
        const SizedBox(height: 12),
        buildNumberField(
          name: CalculationFields.desiredAcidity,
          label: 'Desired acidity',
          suffix: 'g/l',
          initialValue: initialAcidity,
          enabled: enabled,
          presets: FieldPresets.desiredAcidity,
        ),
      ],
    );
  }
}

/// Inputs describing the collected must (juice) the user measured.
class MustMeasurementFields extends StatelessWidget {
  const MustMeasurementFields({
    super.key,
    this.initialVolume,
    this.initialSugar,
    this.initialAcidity,
    this.enabled = true,
  });

  final String? initialVolume;
  final String? initialSugar;
  final String? initialAcidity;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildNumberField(
          name: CalculationFields.volume,
          label: 'Collected volume',
          suffix: 'l',
          initialValue: initialVolume,
          enabled: enabled,
        ),
        const SizedBox(height: 12),
        buildNumberField(
          name: CalculationFields.mustSugar,
          label: 'Sugar',
          suffix: 'Blg',
          initialValue: initialSugar,
          enabled: enabled,
          presets: FieldPresets.measuredSweetness,
        ),
        const SizedBox(height: 12),
        buildNumberField(
          name: CalculationFields.mustAcidity,
          label: 'Acidity',
          suffix: 'g/l',
          initialValue: initialAcidity,
          enabled: enabled,
          presets: FieldPresets.measuredAcidity,
        ),
      ],
    );
  }
}
