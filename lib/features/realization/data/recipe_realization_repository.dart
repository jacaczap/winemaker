import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/core/database/drift_value_extension.dart';
import 'package:winemaker/features/realization/domain/recipe_realization.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';

part 'recipe_realization_repository.g.dart';

class RecipeRealizationRepository {
  RecipeRealizationRepository(this._database);

  final MyDatabase _database;

  Stream<List<RecipeRealization>> watchAll() => _database
      .recipeRealizationDao
      .watchOrdered()
      .map((rows) => rows.map(_toDomain).toList(growable: false));

  Future<RecipeRealization?> byId(int id) => _database.recipeRealizationDao
      .recipeRealizationById(id)
      .then((data) => data == null ? null : _toDomain(data));

  /// Creates a new realization for [recipe] and returns its id.
  Future<int> create(AvailableRecipes recipe) async {
    final id = await _nextId();
    await _database.recipeRealizationDao.addRecipeRealization(
      RecipeRealizationEntityData(
        id: id,
        currentTask: 0,
        recipe: recipe,
        startTime: DateTime.now(),
        completed: false,
      ),
    );
    return id;
  }

  Future<void> updateCurrentTask(
    int id,
    int currentTask, {
    bool? completed,
  }) =>
      _database.recipeRealizationDao.updateRecipeRealization(
        id,
        RecipeRealizationEntityCompanion(
          currentTask: currentTask.toDriftValue(),
          completed:
              completed == null ? const Value.absent() : completed.toDriftValue(),
        ),
      );

  /// Deletes a realization and all of its per-task state.
  Future<void> delete(int id) async {
    await _database.taskStateDao.deleteAllFor(id);
    await _database.recipeRealizationDao.deleteRecipeRealization(id);
  }

  Future<int> _nextId() async {
    final all =
        await _database.recipeRealizationDao.allRecipeRealizationEntries;
    if (all.isEmpty) return 1;
    return all.map((r) => r.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  RecipeRealization _toDomain(RecipeRealizationEntityData data) =>
      RecipeRealization(
        id: data.id,
        currentTask: data.currentTask,
        recipe: data.recipe,
        startTime: data.startTime,
        completed: data.completed,
      );
}

@riverpod
RecipeRealizationRepository recipeRealizationRepository(Ref ref) =>
    RecipeRealizationRepository(ref.watch(databaseProvider));
