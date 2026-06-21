import 'package:winemaker/core/widgets/field_preset.dart';

/// Suggested values for calculations/calculator fields, sourced from the
/// "Reference values" section of `project.mdc`. Ranges fill a representative
/// value; the
/// description keeps the original range or source for context.
class FieldPresets {
  const FieldPresets._();

  static const desiredAcidity = <FieldPreset>[
    FieldPreset(label: 'Dry', value: '7', description: '6.5–7.5 g/l'),
    FieldPreset(label: 'Semi-dry', value: '7', description: '6.5–7.5 g/l'),
    FieldPreset(label: 'Semi-sweet', value: '7.25', description: '6.5–8.0 g/l'),
    FieldPreset(label: 'Sweet', value: '7.75', description: '6.5–9.0 g/l'),
    FieldPreset(label: 'Red table wine', value: '7', description: '6–8 g/l'),
    FieldPreset(label: 'White table wine', value: '8', description: '7–9 g/l'),
  ];

  static const desiredSweetness = <FieldPreset>[
    FieldPreset(label: 'Dry', value: '5', description: '0–10 g/l'),
    FieldPreset(label: 'Semi-dry', value: '30', description: '20–40 g/l'),
    FieldPreset(label: 'Semi-sweet', value: '47', description: '45–50 g/l'),
    FieldPreset(label: 'Sweet', value: '110', description: '100–120 g/l'),
  ];

  static const desiredAlcohol = <FieldPreset>[
    FieldPreset(
        label: 'Light / sparkling', value: '9', description: '5.5–12.5 %'),
    FieldPreset(label: 'Light white', value: '10', description: '8–12 %'),
    FieldPreset(label: 'Full white', value: '13.5', description: '12.5–14.5 %'),
    FieldPreset(label: 'Light red', value: '12', description: '11–13 %'),
    FieldPreset(label: 'Full red', value: '14', description: '13.5–15 %'),
    FieldPreset(label: 'Table wine', value: '13', description: '11–15 %'),
    FieldPreset(label: 'Dessert', value: '15', description: '10–20 %'),
    FieldPreset(label: 'Fortified', value: '18.5', description: '15–22 %'),
  ];

  static const measuredAcidity = <FieldPreset>[
    FieldPreset(
        label: 'White grape', value: '7.4', description: 'e.g. Johanniter 7–9'),
    FieldPreset(
        label: 'Red grape', value: '6.3', description: 'e.g. Regent 6–7'),
    FieldPreset(
        label: 'Cool-climate must', value: '7', description: '5.5–9 g/l'),
  ];

  static const measuredSweetness = <FieldPreset>[
    FieldPreset(label: 'Apple', value: '13'),
    FieldPreset(label: 'Pear', value: '15'),
    FieldPreset(label: 'Plum', value: '14'),
    FieldPreset(label: 'Sweet cherry', value: '14'),
    FieldPreset(label: 'Sour cherry', value: '12'),
    FieldPreset(label: 'Blackcurrant', value: '15'),
    FieldPreset(label: 'Redcurrant', value: '10.5'),
    FieldPreset(label: 'Raspberry', value: '10.5'),
    FieldPreset(label: 'Gooseberry', value: '8'),
    FieldPreset(label: 'Strawberry', value: '8'),
    FieldPreset(label: 'Grape', value: '18', description: '16–21 Blg'),
  ];
}
