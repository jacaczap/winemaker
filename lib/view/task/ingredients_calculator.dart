import 'package:flutter/material.dart';
import 'package:winemaker/src/desired_wine/desired_wine.dart';
import 'package:winemaker/src/desired_wine/desired_wine_service.dart';
import 'package:winemaker/src/future/future_mapper.dart';
import 'package:winemaker/src/ingredients/ingredients_service.dart';
import 'package:winemaker/src/must/must_measurements.dart';
import 'package:winemaker/src/must/must_service.dart';
import 'package:winemaker/view/constants.dart';
import 'package:winemaker/view/utils/future_builder.dart';

class IngredientsCalculatorDisplay extends StatelessWidget {
  const IngredientsCalculatorDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _must = getMustMeasurementsById(1, context);

    var _desiredWineParameters = getDesiredWineById(1, context);

    final List<Widget> mustParameters = _getMustParameterDisplay(_desiredWineParameters, _must);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Ingredients calculator'),
        ),
        body: Column(children: [
          Expanded(child: ListView(children: mustParameters)),
          ElevatedButton(
            child: const Text("Calculate required ingredients"),
            onPressed: () {
              calculateAndSaveIngredients(_desiredWineParameters, _must, context);
              Navigator.pop(context, true);
            },
          ),
        ]));
  }

  List<Widget> _getMustParameterDisplay(Future<DesiredWine> _desiredWineParameters, Future<MustMeasurements> _must) {
    var _volume = _must.map((must) => must.volume.toString());
    var _sugar = _must.map((must) => must.sugar.toString());
    var _desiredAlcohol = _desiredWineParameters.map((desiredWine) => desiredWine.alcohol.toString());
    var _desiredSugar = _desiredWineParameters.map((desiredWine) => desiredWine.sugar.toString());

    return [
      const Text("Must parameters", textAlign: TextAlign.center, style: biggerFont),
      getTextFutureBuilder(_volume, "Volume", "l"),
      getTextFutureBuilder(_sugar, "Sugar", "Blg"),
      const Divider(),
      const Text("Desired wine parameters", textAlign: TextAlign.center, style: biggerFont),
      getTextFutureBuilder(_desiredAlcohol, "Alcohol", "%"),
      getTextFutureBuilder(_desiredSugar, "Sugar", "g/l"),
    ];
  }
}
