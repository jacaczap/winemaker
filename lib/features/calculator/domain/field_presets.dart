import 'package:winemaker/core/widgets/field_preset.dart';
import 'package:winemaker/l10n/app_localizations.dart';

/// Typical readings for the fields the user *measures*, sourced from the
/// "Reference values" section of `project.mdc`.
///
/// The desired-wine fields have no presets: their sliders already show the
/// realistic span, and the sweetness slider names the style it is in.
///
/// Labels and worded descriptions are localized; pure numeric ranges (units
/// such as g/l, %, Blg) are kept verbatim as they read the same in any locale.
class FieldPresets {
  const FieldPresets._();

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
        FieldPreset(
            label: l10n.presetGrape, value: '18', description: '16–21 Blg'),
      ];
}
