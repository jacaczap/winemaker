import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/core/database/drift_value_extension.dart';
import 'package:winemaker/features/realization/domain/recipe_realization.dart';

part 'recipe_realization_repository.g.dart';

class RecipeRealizationRepository {
  RecipeRealizationRepository(this._database);

  final MyDatabase _database;

  Future<void> saveInitial(int id, RecipeRealization realization) =>
      _database.recipeRealizationDao.addRecipeRealization(
        RecipeRealizationEntityData(
          id: id,
          currentTask: realization.currentTask,
          recipe: realization.recipe,
        ),
      );

  Future<void> updateCurrentTask(int id, int currentTask) =>
      _database.recipeRealizationDao.updateRecipeRealization(
          id, RecipeRealizationEntityCompanion(currentTask: currentTask.toDriftValue()));

  Future<void> revertCurrentTask(int id, int currentTask) =>
      updateCurrentTask(id, currentTask - 1);

  Future<RecipeRealization?> byId(int id) => _database.recipeRealizationDao
      .recipeRealizationById(id)
      .then((data) =>
          data == null ? null : RecipeRealization(data.currentTask, data.recipe));
}

@riverpod
RecipeRealizationRepository recipeRealizationRepository(Ref ref) =>
    RecipeRealizationRepository(ref.watch(databaseProvider));
