import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/features/realization/data/recipe_realization_dao.dart';
import 'package:winemaker/features/realization/data/recipe_realization_entity.dart';
import 'package:winemaker/features/realization/data/task_state_dao.dart';
import 'package:winemaker/features/realization/data/task_state_entity.dart';
import 'package:winemaker/features/realization/domain/task_state.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [RecipeRealizationEntity, TaskStateEntity],
  daos: [RecipeRealizationDao, TaskStateDao],
)
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(driftDatabase(name: 'db'));

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 3) {
            await m.createTable(taskStateEntity);
          }
          if (from < 4) {
            await customStatement('DROP TABLE IF EXISTS desired_wine_entity');
            await customStatement('DROP TABLE IF EXISTS must_entity');
            await customStatement('DROP TABLE IF EXISTS ingredients_entity');
          }
        },
      );
}

@Riverpod(keepAlive: true)
MyDatabase database(Ref ref) {
  final database = MyDatabase();
  ref.onDispose(database.close);
  return database;
}
