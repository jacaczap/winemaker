import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/features/realization/data/recipe_realization_repository.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/realization/domain/initial_measurement_payload.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/features/recipe/domain/task.dart';

/// Upgrading a pre-restructure database must keep finished work finished.
///
/// The old schema stored task state by position, so the migration has to turn
/// those positions into task ids and move each realization's pointer to the
/// equivalent task in the reordered recipe.
void main() {
  late Database sqlite;
  late MyDatabase db;
  late TaskStateRepository taskStates;
  late RecipeRealizationRepository realizations;

  setUp(() {
    sqlite = sqlite3.openInMemory();
    _createLegacySchema(sqlite);
    db = MyDatabase.forTesting(NativeDatabase.opened(sqlite));
    taskStates = TaskStateRepository(db);
    realizations = RecipeRealizationRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  const legacyCalculations = '{"desiredAlcohol":13.0,"desiredSweetness":5.0,'
      '"desiredAcidity":7.0,"mustVolume":20.0,"mustSugar":18.5,'
      '"mustAcidity":9.0,"sugarToAdd":3.2,"waterToAdd":5.0,'
      '"yeast":true,"nutrients":true}';
  const legacyAddedIngredients = '{"addedSugar":1.5,"addedWater":5.0,'
      '"addedYeast":true,"addedNutrients":true}';

  final tasks = redWineRecipe.tasks;
  int indexOf(RecipeTaskId id) => tasks.indexWhere((t) => t.id == id);

  test('a realization fermenting on skins keeps its place', () async {
    _insertRealization(sqlite, id: 1, currentTask: 3);
    _insertTaskState(sqlite, taskIndex: 1, payload: legacyCalculations);
    _insertTaskState(sqlite, taskIndex: 2, payload: legacyAddedIngredients);

    final realization = await realizations.byId(1);

    expect(
      realization!.currentTask,
      equals(indexOf(RecipeTaskId.fermentWithSkins)),
    );
  });

  test('the pre-fermentation sweetness is recovered from the old calculation',
      () async {
    _insertRealization(sqlite, id: 1, currentTask: 3);
    _insertTaskState(sqlite, taskIndex: 1, payload: legacyCalculations);

    final record = await taskStates.get(1, RecipeTaskId.initialSweetness);

    expect(record, isNotNull);
    expect(
      InitialMeasurementPayload.fromJson(record!.payloadJson!).sweetness.value,
      equals(18.5),
    );
  });

  test('old task data is re-keyed onto the same tasks', () async {
    _insertRealization(sqlite, id: 1, currentTask: 7);
    _insertTaskState(
      sqlite,
      taskIndex: 6,
      payload: '{"addedSugar":2.0,"addedWater":0.0,'
          '"addedYeast":false,"addedNutrients":false}',
    );

    final record = await taskStates.get(1, RecipeTaskId.addRemainingSugar);

    expect(record, isNotNull);
    expect(record!.payloadJson!['addedSugar'], equals(2.0));
  });

  test('a realization past pressing does not lose finished tasks', () async {
    _insertRealization(sqlite, id: 1, currentTask: 8);
    _insertTaskState(sqlite, taskIndex: 1, payload: legacyCalculations);

    final realization = await realizations.byId(1);

    expect(realization!.currentTask, equals(indexOf(RecipeTaskId.rackWine)));
  });

  test('a completed realization stays completed', () async {
    _insertRealization(sqlite, id: 1, currentTask: 14, completed: true);

    final realization = await realizations.byId(1);

    expect(realization!.currentTask, equals(tasks.length));
    expect(realization.completed, isTrue);
  });

  test('a realization that never got past the first task is untouched',
      () async {
    _insertRealization(sqlite, id: 1, currentTask: 0);

    final realization = await realizations.byId(1);

    expect(realization!.currentTask, equals(0));
    expect(await taskStates.listForRealization(1), isEmpty);
  });
}

void _createLegacySchema(Database sqlite) {
  sqlite.execute('''
    CREATE TABLE recipe_realization_entity (
      id INTEGER NOT NULL,
      current_task INTEGER NOT NULL,
      recipe INTEGER NOT NULL,
      name TEXT NULL,
      start_time INTEGER NOT NULL DEFAULT (strftime('%s', CURRENT_TIMESTAMP)),
      completed INTEGER NOT NULL DEFAULT 0,
      PRIMARY KEY (id)
    )
  ''');
  sqlite.execute('''
    CREATE TABLE task_state_entity (
      realization_id INTEGER NOT NULL,
      task_index INTEGER NOT NULL,
      status TEXT NOT NULL,
      payload TEXT NULL,
      PRIMARY KEY (realization_id, task_index)
    )
  ''');
  sqlite.execute('PRAGMA user_version = 6');
}

void _insertRealization(
  Database sqlite, {
  required int id,
  required int currentTask,
  bool completed = false,
}) =>
    sqlite.execute(
      'INSERT INTO recipe_realization_entity '
      '(id, current_task, recipe, start_time, completed) '
      'VALUES (?, ?, 0, 0, ?)',
      [id, currentTask, completed ? 1 : 0],
    );

void _insertTaskState(
  Database sqlite, {
  required int taskIndex,
  String? payload,
  int realizationId = 1,
}) =>
    sqlite.execute(
      'INSERT INTO task_state_entity '
      '(realization_id, task_index, status, payload) '
      "VALUES (?, ?, 'completed', ?)",
      [realizationId, taskIndex, payload],
    );
