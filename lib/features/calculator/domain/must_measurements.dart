import 'package:winemaker/core/models/litres.dart';
import 'package:winemaker/core/models/sugar.dart';

class MustMeasurements {
  final Litres volume;
  final Blg sugar;
  final GramsPerLiter acidity;

  const MustMeasurements(this.volume, this.sugar, this.acidity);
}
