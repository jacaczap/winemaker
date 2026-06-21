import 'package:flutter/material.dart';
import 'package:winemaker/core/widgets/form_builder.dart';

/// Field names shared by the setup screen and the standalone calculator so
/// both read the same values out of the enclosing `FormBuilder`.
class SetupFields {
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
  });

  final String? initialAlcohol;
  final String? initialSweetness;
  final String? initialAcidity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildNumberField(
          name: SetupFields.alcohol,
          label: 'Desired alcohol',
          suffix: '%',
          initialValue: initialAlcohol,
        ),
        const SizedBox(height: 12),
        buildNumberField(
          name: SetupFields.sweetness,
          label: 'Desired sweetness',
          suffix: 'g/l',
          initialValue: initialSweetness,
        ),
        const SizedBox(height: 12),
        buildNumberField(
          name: SetupFields.desiredAcidity,
          label: 'Desired acidity',
          suffix: 'g/l',
          initialValue: initialAcidity,
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
  });

  final String? initialVolume;
  final String? initialSugar;
  final String? initialAcidity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildNumberField(
          name: SetupFields.volume,
          label: 'Collected volume',
          suffix: 'l',
          initialValue: initialVolume,
        ),
        const SizedBox(height: 12),
        buildNumberField(
          name: SetupFields.mustSugar,
          label: 'Sugar',
          suffix: 'Blg',
          initialValue: initialSugar,
        ),
        const SizedBox(height: 12),
        buildNumberField(
          name: SetupFields.mustAcidity,
          label: 'Acidity',
          suffix: 'g/l',
          initialValue: initialAcidity,
        ),
      ],
    );
  }
}
