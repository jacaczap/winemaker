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

  Future<RecipeRealizationEntityData?> recipeRealizationById(int id) =>
      (select(recipeRealizationEntity)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<int> addRecipeRealization(RecipeRealizationEntityData realization) =>
      into(recipeRealizationEntity).insertOnConflictUpdate(realization);

  Future updateRecipeRealization(
          int id, RecipeRealizationEntityCompanion realization) =>
      (update(recipeRealizationEntity)..where((i) => i.id.equals(id)))
          .write(realization);
}
