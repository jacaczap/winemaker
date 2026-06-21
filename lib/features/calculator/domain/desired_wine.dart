import 'package:winemaker/core/models/alcohol.dart';
import 'package:winemaker/core/models/sugar.dart';

class DesiredWine {
  final Alcohol alcohol;
  final GramsPerLiter sugar;

  const DesiredWine(this.alcohol, this.sugar);
}
