import 'package:winemaker/src/common_models/litres.dart';
import 'package:winemaker/src/common_models/sugar.dart';

class Ingredients {
  final Kilograms sugar;
  final Litres water;
  final bool yeast;
  final bool nutrients;

  const Ingredients(this.sugar, this.water, this.yeast, this.nutrients);
}
