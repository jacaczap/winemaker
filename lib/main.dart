import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winemaker/src/database/database.dart';
import 'package:winemaker/view/recipe/recipe_view.dart';

Future<void> main() async => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<MyDatabase>(
      create: (context) => MyDatabase(),
      child: MaterialApp(
        title: 'Welcome to Winemaker',
        theme: FlexThemeData.light(scheme: FlexScheme.redWine),
        home: const StartWineMaker(),
      ),
      dispose: (context, db) => db.close(),
    );
  }
}

class StartWineMaker extends StatelessWidget {
  const StartWineMaker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Welcome to Winemaker')),
        body: Center(
          child: ElevatedButton(
            child: const Text("Start Winemaker"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RecipeViewWrapper(realizationId: 1)),
              );
            },
          ),
        ));
  }
}
