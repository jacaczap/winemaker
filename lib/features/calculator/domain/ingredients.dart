import 'package:winemaker/core/models/litres.dart';
import 'package:winemaker/core/models/sugar.dart';

class Ingredients {
  final Kilograms sugar;
  final Litres water;
  final bool yeast;
  final bool nutrients;

  const Ingredients(this.sugar, this.water, this.yeast, this.nutrients);
}
