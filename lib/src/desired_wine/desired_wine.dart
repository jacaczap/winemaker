import 'package:winemaker/src/common_models/alcohol.dart';
import 'package:winemaker/src/common_models/sugar.dart';

class DesiredWine {
  final Alcohol alcohol;
  final GramsPerLiter sugar;

  const DesiredWine(this.alcohol, this.sugar);
}
