import 'package:drift/drift.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/features/realization/data/recipe_realization_entity.dart';

part 'recipe_realization_dao.g.dart';

@DriftAccessor(tables: [RecipeRealizationEntity])
class RecipeRealizationDao extends DatabaseAccessor<MyDatabase>
    with _$RecipeRealizationDaoMixin {
  RecipeRealizationDao(super.db);

  Future<List<RecipeRealizationEntityData>> get allRecipeRealizationEntries =>
      select(recipeRealizationEntity).get();

  /// Realizations ordered for the home list: in-progress first, then by most
  /// recent start time, with completed ones sorted to the bottom.
  Stream<List<RecipeRealizationEntityData>> watchOrdered() =>
      (select(recipeRealizationEntity)
            ..orderBy([
              (t) => OrderingTerm.asc(t.completed),
              (t) => OrderingTerm.desc(t.startTime),
            ]))
          .watch();

  Future<RecipeRealizationEntityData?> recipeRealizationById(int id) =>
      (select(recipeRealizationEntity)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<int> addRecipeRealization(RecipeRealizationEntityData realization) =>
      into(recipeRealizationEntity).insertOnConflictUpdate(realization);

  Future updateRecipeRealization(
          int id, RecipeRealizationEntityCompanion realization) =>
      (update(recipeRealizationEntity)..where((i) => i.id.equals(id)))
          .write(realization);

  Future<int> deleteRecipeRealization(int id) =>
      (delete(recipeRealizationEntity)..where((t) => t.id.equals(id))).go();
}
