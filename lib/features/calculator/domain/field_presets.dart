import 'package:winemaker/core/widgets/field_preset.dart';
import 'package:winemaker/l10n/app_localizations.dart';

/// Suggested values for calculations/calculator fields, sourced from the
/// "Reference values" section of `project.mdc`. Ranges fill a representative
/// value; the description keeps the original range or source for context.
///
/// Labels and worded descriptions are localized; pure numeric ranges (units
/// such as g/l, %, Blg) are kept verbatim as they read the same in any locale.
class FieldPresets {
  const FieldPresets._();

  static List<FieldPreset> desiredAcidity(AppLocalizations l10n) => [
        FieldPreset(label: l10n.presetDry, value: '7', description: '6.5–7.5 g/l'),
        FieldPreset(
            label: l10n.presetSemiDry, value: '7', description: '6.5–7.5 g/l'),
        FieldPreset(
            label: l10n.presetSemiSweet,
            value: '7.25',
            description: '6.5–8.0 g/l'),
        FieldPreset(
            label: l10n.presetSweet, value: '7.75', description: '6.5–9.0 g/l'),
        FieldPreset(
            label: l10n.presetRedTableWine, value: '7', description: '6–8 g/l'),
        FieldPreset(
            label: l10n.presetWhiteTableWine, value: '8', description: '7–9 g/l'),
      ];

  static List<FieldPreset> desiredSweetness(AppLocalizations l10n) => [
        FieldPreset(label: l10n.presetDry, value: '5', description: '0–10 g/l'),
        FieldPreset(
            label: l10n.presetSemiDry, value: '30', description: '20–40 g/l'),
        FieldPreset(
            label: l10n.presetSemiSweet, value: '47', description: '45–50 g/l'),
        FieldPreset(
            label: l10n.presetSweet, value: '110', description: '100–120 g/l'),
      ];

  static List<FieldPreset> desiredAlcohol(AppLocalizations l10n) => [
        FieldPreset(
            label: l10n.presetLightSparkling,
            value: '9',
            description: '5.5–12.5 %'),
        FieldPreset(
            label: l10n.presetLightWhite, value: '10', description: '8–12 %'),
        FieldPreset(
            label: l10n.presetFullWhite, value: '13.5', description: '12.5–14.5 %'),
        FieldPreset(
            label: l10n.presetLightRed, value: '12', description: '11–13 %'),
        FieldPreset(
            label: l10n.presetFullRed, value: '14', description: '13.5–15 %'),
        FieldPreset(
            label: l10n.presetTableWine, value: '13', description: '11–15 %'),
        FieldPreset(
            label: l10n.presetDessert, value: '15', description: '10–20 %'),
        FieldPreset(
            label: l10n.presetFortified, value: '18.5', description: '15–22 %'),
      ];

  static List<FieldPreset> measuredAcidity(AppLocalizations l10n) => [
        FieldPreset(
            label: l10n.presetWhiteGrape,
            value: '7.4',
            description: l10n.presetEgJohanniter),
        FieldPreset(
            label: l10n.presetRedGrape,
            value: '6.3',
            description: l10n.presetEgRegent),
        FieldPreset(
            label: l10n.presetCoolClimateMust,
            value: '7',
            description: '5.5–9 g/l'),
      ];

  static List<FieldPreset> measuredSweetness(AppLocalizations l10n) => [
        FieldPreset(label: l10n.presetApple, value: '13'),
        FieldPreset(label: l10n.presetPear, value: '15'),
        FieldPreset(label: l10n.presetPlum, value: '14'),
        FieldPreset(label: l10n.presetSweetCherry, value: '14'),
        FieldPreset(label: l10n.presetSourCherry, value: '12'),
        FieldPreset(label: l10n.presetBlackcurrant, value: '15'),
        FieldPreset(label: l10n.presetRedcurrant, value: '10.5'),
        FieldPreset(label: l10n.presetRaspberry, value: '10.5'),
        FieldPreset(label: l10n.presetGooseberry, value: '8'),
        FieldPreset(label: l10n.presetStrawberry, value: '8'),
        FieldPreset(label: l10n.presetGrape, value: '18', description: '16–21 Blg'),
      ];
}
