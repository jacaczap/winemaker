import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/features/recipe/domain/task.dart';
import 'package:winemaker/features/realization/data/recipe_realization_dao.dart';
import 'package:winemaker/features/realization/data/recipe_realization_entity.dart';
import 'package:winemaker/features/realization/data/task_state_dao.dart';
import 'package:winemaker/features/realization/data/task_state_entity.dart';
import 'package:winemaker/features/realization/domain/task_state.dart';

part 'database.g.dart';

/// Task order of the red wine recipe before task state was keyed by task id.
///
/// Old rows stored a position, so this list is what turns those positions back
/// into the ids they meant. It must never change.
const _legacyRedWineTaskOrder = [
  RecipeTaskId.prepareFruit,
  RecipeTaskId.calculations,
  RecipeTaskId.addIngredients,
  RecipeTaskId.fermentWithSkins,
  RecipeTaskId.moveToCarboy,
  RecipeTaskId.waitSugarDrop,
  RecipeTaskId.addRemainingSugar,
  RecipeTaskId.waitFermentationSlow,
  RecipeTaskId.rackWine,
  RecipeTaskId.matureWine,
  RecipeTaskId.rackWineAgain,
  RecipeTaskId.matureWineAgain,
  RecipeTaskId.bottleWine,
  RecipeTaskId.result,
];

@DriftDatabase(
  tables: [RecipeRealizationEntity, TaskStateEntity],
  daos: [RecipeRealizationDao, TaskStateDao],
)
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(driftDatabase(name: 'db'));

  /// Builds a database on a caller-provided executor, used by tests to run
  /// against an in-memory `NativeDatabase`.
  MyDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 7;

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
          if (from < 5) {
            await m.addColumn(
                recipeRealizationEntity, recipeRealizationEntity.startTime);
            await m.addColumn(
                recipeRealizationEntity, recipeRealizationEntity.completed);
          }
          if (from < 6) {
            await m.addColumn(
                recipeRealizationEntity, recipeRealizationEntity.name);
          }
          if (from < 7) {
            await _rekeyTaskStateByTaskId(m, hasLegacyRows: from >= 3);
          }
        },
      );

  /// Rewrites task state from positions to task ids and re-points every
  /// realization at the equivalent task in the restructured recipe.
  ///
  /// Also seeds the new initial-sweetness task from the old calculations
  /// payload, which already held the pre-fermentation reading.
  Future<void> _rekeyTaskStateByTaskId(
    Migrator m, {
    required bool hasLegacyRows,
  }) async {
    final legacyRows = hasLegacyRows
        ? await customSelect(
            'SELECT realization_id, task_index, status, payload '
            'FROM task_state_entity',
          ).get()
        : <QueryRow>[];
    final realizations = await customSelect(
      'SELECT id, current_task FROM recipe_realization_entity',
    ).get();

    if (hasLegacyRows) {
      await customStatement('DROP TABLE task_state_entity');
      await m.createTable(taskStateEntity);
    }

    final tasks = redWineRecipe.tasks;
    for (final realization in realizations) {
      final realizationId = realization.read<int>('id');
      final legacyCurrentTask = realization.read<int>('current_task');
      final rows = legacyRows
          .where((r) => r.read<int>('realization_id') == realizationId)
          .toList(growable: false);

      double? sweetness;
      for (final row in rows) {
        final taskId = _legacyTaskId(row.read<int>('task_index'));
        if (taskId == null) continue;
        final payload = row.read<String?>('payload');
        if (taskId == RecipeTaskId.calculations && payload != null) {
          sweetness = _legacySweetness(payload);
        }
        await into(taskStateEntity).insert(TaskStateEntityData(
          realizationId: realizationId,
          taskId: taskId,
          status: TaskState.values.byName(row.read<String>('status')),
          payload: payload,
        ));
      }

      final done = _legacyCompletedTaskIds(legacyCurrentTask);
      if (sweetness != null) {
        await into(taskStateEntity).insert(TaskStateEntityData(
          realizationId: realizationId,
          taskId: RecipeTaskId.initialSweetness,
          status: TaskState.completed,
          payload: jsonEncode({'mustSugar': sweetness}),
        ));
      }

      final currentTask = legacyCurrentTask >= _legacyRedWineTaskOrder.length
          ? tasks.length
          : tasks.indexWhere((t) => !done.contains(t.id));
      await customStatement(
        'UPDATE recipe_realization_entity SET current_task = ? WHERE id = ?',
        [currentTask < 0 ? tasks.length : currentTask, realizationId],
      );
    }
  }
}

RecipeTaskId? _legacyTaskId(int taskIndex) =>
    taskIndex >= 0 && taskIndex < _legacyRedWineTaskOrder.length
        ? _legacyRedWineTaskOrder[taskIndex]
        : null;

double? _legacySweetness(String payload) {
  final json = jsonDecode(payload) as Map<String, dynamic>;
  return (json['mustSugar'] as num?)?.toDouble();
}

/// The tasks a realization had finished under the old recipe, expressed as ids.
///
/// The two tasks the restructure introduced are counted as finished when their
/// old-flow equivalent was: the sweetness was read at the old calculations
/// step, and sugar and water went in with the yeast before pressing.
Set<RecipeTaskId> _legacyCompletedTaskIds(int legacyCurrentTask) {
  final done = _legacyRedWineTaskOrder
      .take(legacyCurrentTask.clamp(0, _legacyRedWineTaskOrder.length))
      .toSet();
  if (done.contains(RecipeTaskId.calculations)) {
    done.add(RecipeTaskId.initialSweetness);
    if (done.contains(RecipeTaskId.moveToCarboy)) {
      done.add(RecipeTaskId.addWaterAndSugar);
    }
  }
  return done;
}

@Riverpod(keepAlive: true)
MyDatabase database(Ref ref) {
  final database = MyDatabase();
  ref.onDispose(database.close);
  return database;
}
