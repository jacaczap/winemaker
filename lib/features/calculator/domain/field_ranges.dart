import 'package:winemaker/l10n/app_localizations.dart';

/// The realistic span a numeric field's slider covers.
///
/// Values outside the span are still accepted when typed; the slider thumb
/// only pins at the end.
class FieldRange {
  const FieldRange({
    required this.min,
    required this.max,
    required this.step,
    this.ticks = const [],
    this.typical,
  });

  final double min;
  final double max;
  final double step;

  /// Positions marked on the slider track.
  final List<double> ticks;

  /// Span highlighted on the track as the usual, safe choice.
  final ({double min, double max})? typical;

  bool contains(double value) => value >= min && value <= max;
}

/// Slider spans for the calculation fields, see `docs/plan-slider-inputs.md`
/// for the reasoning behind each number.
///
/// Sources: Ustawa o wyrobach winiarskich (2021) art. 5 for the legal alcohol
/// span of fruit wine, Rozporządzenie MRiRW Dz.U. 2022 poz. 2113 §12 for
/// acidity, yeast datasheets for the alcohol ceiling (Alcotec 23% turbo is the
/// strongest sold, ordinary wine yeast stops at 14-16%), and published fruit
/// sugar and acid tables for the must spans.
class FieldRanges {
  const FieldRanges._();

  static const desiredAlcohol = FieldRange(min: 5.5, max: 23, step: 0.5);

  static const desiredSweetness =
      FieldRange(min: 0, max: 80, step: 1, ticks: [15, 30, 60]);

  static const desiredAcidity =
      FieldRange(min: 4, max: 12, step: 0.5, typical: (min: 6, max: 8));

  /// Middle of [desiredAcidity]'s typical band, the value a fresh form starts
  /// on so the user only has to move it when they want something unusual.
  static const defaultDesiredAcidity = '7';

  static const mustSweetness = FieldRange(min: 2, max: 26, step: 0.5);

  static const mustAcidity = FieldRange(min: 3, max: 35, step: 0.5);

  static const volume = FieldRange(min: 5, max: 50, step: 0.5);
}

/// Sweetness bands a home fruit wine is judged by, from the Polish fruit-wine
/// regulation (Dz.U. 2022 poz. 2113 §9).
///
/// Deliberately not the EU grape-wine bands, which sit about three times
/// lower: fruit musts are far more acidic, and acidity suppresses perceived
/// sweetness, so fruit wine needs more sugar to taste equally sweet. The
/// German fruit-wine standard lands on the same numbers.
enum SweetnessStyle {
  dry(15),
  semiDry(30),
  semiSweet(60),
  sweet(150);

  const SweetnessStyle(this.upperBound);

  /// Highest residual sugar in g/l still counted as this style.
  final double upperBound;

  static SweetnessStyle of(double gramsPerLiter) => values.firstWhere(
        (style) => gramsPerLiter <= style.upperBound,
        orElse: () => sweet,
      );

  String label(AppLocalizations l10n) => switch (this) {
        dry => l10n.presetDry,
        semiDry => l10n.presetSemiDry,
        semiSweet => l10n.presetSemiSweet,
        sweet => l10n.presetSweet,
      };
}
