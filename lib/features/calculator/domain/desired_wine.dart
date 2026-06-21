import 'package:winemaker/core/models/alcohol.dart';
import 'package:winemaker/core/models/sugar.dart';

class DesiredWine {
  final Alcohol alcohol;
  final GramsPerLiter sugar;
  final GramsPerLiter acidity;

  const DesiredWine(this.alcohol, this.sugar, this.acidity);
}
