import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/realization/domain/task_state.dart';
import 'package:winemaker/features/recipe/domain/task.dart';

/// Adding notes and completion times must leave existing work readable, just
/// without any recorded times.
void main() {
  late Database sqlite;
  late MyDatabase db;
  late TaskStateRepository taskStates;

  setUp(() {
    sqlite = sqlite3.openInMemory();
    _createSchemaVersion7(sqlite);
    db = MyDatabase.forTesting(NativeDatabase.opened(sqlite));
    taskStates = TaskStateRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('stored task data survives with empty note and time', () async {
    sqlite.execute(
      'INSERT INTO task_state_entity '
      '(realization_id, task_id, status, payload) '
      "VALUES (1, 'initialSweetness', 'completed', '{\"mustSugar\":18.5}')",
    );

    final record = await taskStates.get(1, RecipeTaskId.initialSweetness);

    expect(record!.status, equals(TaskState.completed));
    expect(record.payloadJson!['mustSugar'], equals(18.5));
    expect(record.notes, isNull);
    expect(record.completedAt, isNull);
  });

  test('a note can be written onto a migrated row', () async {
    sqlite.execute(
      'INSERT INTO task_state_entity (realization_id, task_id, status) '
      "VALUES (1, 'prepareFruit', 'completed')",
    );

    await taskStates.saveNotes(1, RecipeTaskId.prepareFruit, 'plums');

    final record = await taskStates.get(1, RecipeTaskId.prepareFruit);
    expect(record!.notes, equals('plums'));
    expect(record.status, equals(TaskState.completed));
  });
}

void _createSchemaVersion7(Database sqlite) {
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
      task_id TEXT NOT NULL,
      status TEXT NOT NULL,
      payload TEXT NULL,
      PRIMARY KEY (realization_id, task_id)
    )
  ''');
  sqlite.execute('PRAGMA user_version = 7');
}
