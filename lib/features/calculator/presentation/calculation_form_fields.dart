import 'package:flutter/material.dart';
import 'package:winemaker/core/models/alcohol.dart';
import 'package:winemaker/core/models/litres.dart';
import 'package:winemaker/core/models/sugar.dart';
import 'package:winemaker/core/utils/user_input_utils.dart';
import 'package:winemaker/core/widgets/slider_number_field.dart';
import 'package:winemaker/features/calculator/domain/achievable_targets.dart';
import 'package:winemaker/features/calculator/domain/desired_wine.dart';
import 'package:winemaker/features/calculator/domain/field_presets.dart';
import 'package:winemaker/features/calculator/domain/field_ranges.dart';
import 'package:winemaker/features/calculator/domain/must_measurements.dart';
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

/// Reads the desired wine out of form values, treating gaps as zero so the
/// limits can be computed while the form is still being filled in.
DesiredWine readDesiredWine(Map<String, dynamic> values) => DesiredWine(
      Alcohol(tryParseDoubleInput(values[CalculationFields.alcohol]) ?? 0),
      GramsPerLiter(
          tryParseDoubleInput(values[CalculationFields.sweetness]) ?? 0),
      GramsPerLiter(
          tryParseDoubleInput(values[CalculationFields.desiredAcidity]) ?? 0),
    );

/// Reads the must out of form values, or null while a measurement is missing.
///
/// Pass [sweetness] when it was recorded by an earlier task, in which case the
/// form does not ask for it again.
MustMeasurements? readMust(Map<String, dynamic> values, {Blg? sweetness}) {
  final volume = tryParseDoubleInput(values[CalculationFields.volume]);
  final sugar = sweetness ?? _blgOrNull(values[CalculationFields.mustSugar]);
  final acidity = tryParseDoubleInput(values[CalculationFields.mustAcidity]);
  if (volume == null || sugar == null || acidity == null) return null;
  return MustMeasurements(Litres(volume), sugar, GramsPerLiter(acidity));
}

Blg? _blgOrNull(Object? value) {
  final parsed = tryParseDoubleInput(value);
  return parsed == null ? null : Blg(parsed);
}

/// Inputs describing the wine the user wants to make.
///
/// [limits] narrows the sliders to what the measured must can actually reach;
/// pass null while the must is still incomplete.
class DesiredWineFields extends StatelessWidget {
  const DesiredWineFields({
    super.key,
    this.initialAlcohol,
    this.initialSweetness,
    this.initialAcidity,
    this.limits,
    this.enabled = true,
  });

  final String? initialAlcohol;
  final String? initialSweetness;
  final String? initialAcidity;
  final TargetLimits? limits;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final limits = this.limits;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SliderNumberField(
          name: CalculationFields.alcohol,
          label: l10n.fieldDesiredAlcohol,
          suffix: '%',
          range: FieldRanges.desiredAlcohol,
          initialValue: initialAlcohol,
          enabled: enabled,
          hardMin: limits?.minAlcohol.value,
          limitMessage: (value) => l10n.limitAlcoholRaised(value),
        ),
        const SizedBox(height: 12),
        SliderNumberField(
          name: CalculationFields.sweetness,
          label: l10n.fieldDesiredSweetness,
          suffix: 'g/l',
          range: FieldRanges.desiredSweetness,
          initialValue: initialSweetness,
          enabled: enabled,
          caption: (value) => SweetnessStyle.of(value).label(l10n),
        ),
        const SizedBox(height: 12),
        SliderNumberField(
          name: CalculationFields.desiredAcidity,
          label: l10n.fieldDesiredAcidity,
          suffix: 'g/l',
          range: FieldRanges.desiredAcidity,
          initialValue: initialAcidity,
          enabled: enabled,
          hardMax: limits?.maxAcidity.value,
          limitMessage: (value) => l10n.limitAcidityLowered(value),
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
    this.sugarEnabled = true,
  });

  final String? initialVolume;
  final String? initialSugar;
  final String? initialAcidity;
  final bool enabled;

  /// Set to false when the sweetness is carried over from an earlier task and
  /// must not be re-entered here.
  final bool sugarEnabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SliderNumberField(
          name: CalculationFields.volume,
          label: l10n.fieldCollectedVolume,
          suffix: 'l',
          range: FieldRanges.volume,
          initialValue: initialVolume,
          enabled: enabled,
        ),
        const SizedBox(height: 12),
        SliderNumberField(
          name: CalculationFields.mustSugar,
          label: l10n.fieldMustSugar,
          suffix: 'Blg',
          range: FieldRanges.mustSweetness,
          initialValue: initialSugar,
          enabled: enabled && sugarEnabled,
          presets: FieldPresets.measuredSweetness(l10n),
        ),
        const SizedBox(height: 12),
        SliderNumberField(
          name: CalculationFields.mustAcidity,
          label: l10n.fieldMustAcidity,
          suffix: 'g/l',
          range: FieldRanges.mustAcidity,
          initialValue: initialAcidity,
          enabled: enabled,
          presets: FieldPresets.measuredAcidity(l10n),
        ),
      ],
    );
  }
}
