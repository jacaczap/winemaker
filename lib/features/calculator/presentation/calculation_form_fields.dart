import 'package:flutter/material.dart';
import 'package:winemaker/core/widgets/form_builder.dart';
import 'package:winemaker/features/calculator/domain/field_presets.dart';
import 'package:winemaker/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildNumberField(
          l10n: l10n,
          name: CalculationFields.alcohol,
          label: l10n.fieldDesiredAlcohol,
          suffix: '%',
          initialValue: initialAlcohol,
          enabled: enabled,
          presets: FieldPresets.desiredAlcohol(l10n),
        ),
        const SizedBox(height: 12),
        buildNumberField(
          l10n: l10n,
          name: CalculationFields.sweetness,
          label: l10n.fieldDesiredSweetness,
          suffix: 'g/l',
          initialValue: initialSweetness,
          enabled: enabled,
          presets: FieldPresets.desiredSweetness(l10n),
        ),
        const SizedBox(height: 12),
        buildNumberField(
          l10n: l10n,
          name: CalculationFields.desiredAcidity,
          label: l10n.fieldDesiredAcidity,
          suffix: 'g/l',
          initialValue: initialAcidity,
          enabled: enabled,
          presets: FieldPresets.desiredAcidity(l10n),
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
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildNumberField(
          l10n: l10n,
          name: CalculationFields.volume,
          label: l10n.fieldCollectedVolume,
          suffix: 'l',
          initialValue: initialVolume,
          enabled: enabled,
        ),
        const SizedBox(height: 12),
        buildNumberField(
          l10n: l10n,
          name: CalculationFields.mustSugar,
          label: l10n.fieldMustSugar,
          suffix: 'Blg',
          initialValue: initialSugar,
          enabled: enabled,
          presets: FieldPresets.measuredSweetness(l10n),
        ),
        const SizedBox(height: 12),
        buildNumberField(
          l10n: l10n,
          name: CalculationFields.mustAcidity,
          label: l10n.fieldMustAcidity,
          suffix: 'g/l',
          initialValue: initialAcidity,
          enabled: enabled,
          presets: FieldPresets.measuredAcidity(l10n),
        ),
      ],
    );
  }
}
