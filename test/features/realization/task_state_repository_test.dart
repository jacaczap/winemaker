import 'package:flutter_test/flutter_test.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/realization/domain/result_payload.dart';
import 'package:winemaker/features/realization/domain/task_state.dart';
import 'package:winemaker/features/recipe/domain/task.dart';

import '../../helpers/test_database.dart';

void main() {
  late MyDatabase db;
  late TaskStateRepository repository;

  setUp(() {
    db = createTestDatabase();
    repository = TaskStateRepository(db);
  });

  tearDown(() => db.close());

  test('get returns null when nothing was saved', () async {
    expect(await repository.get(1, RecipeTaskId.prepareFruit), isNull);
  });

  test('savePending stores a pending record without payload', () async {
    await repository.savePending(1, RecipeTaskId.prepareFruit);

    final record = await repository.get(1, RecipeTaskId.prepareFruit);
    expect(record, isNotNull);
    expect(record!.status, equals(TaskState.pending));
    expect(record.payloadJson, isNull);
  });

  test('markCompleted round-trips the payload as JSON', () async {
    await repository.markCompleted(
      1,
      RecipeTaskId.result,
      payload: const ResultPayload(results: 'clean', mistakes: 'added late'),
    );

    final record = await repository.get(1, RecipeTaskId.result);
    expect(record!.status, equals(TaskState.completed));

    final payload = ResultPayload.fromJson(record.payloadJson!);
    expect(payload.results, equals('clean'));
    expect(payload.mistakes, equals('added late'));
  });

  test('upsert overwrites the previous row for the same task', () async {
    await repository.savePending(1, RecipeTaskId.prepareFruit);
    await repository.markCompleted(1, RecipeTaskId.prepareFruit);

    final all = await repository.listForRealization(1);
    expect(all, hasLength(1));
    expect(all.single.status, equals(TaskState.completed));
  });

  test('listForRealization returns every stored task', () async {
    await repository.markCompleted(1, RecipeTaskId.prepareFruit);
    await repository.markCompleted(1, RecipeTaskId.calculations);
    await repository.markCompleted(1, RecipeTaskId.result);

    final ids = (await repository.listForRealization(1)).map((r) => r.taskId);

    expect(
      ids,
      unorderedEquals([
        RecipeTaskId.prepareFruit,
        RecipeTaskId.calculations,
        RecipeTaskId.result,
      ]),
    );
  });

  test('discard deletes only the given tasks', () async {
    await repository.markCompleted(1, RecipeTaskId.prepareFruit);
    await repository.markCompleted(1, RecipeTaskId.calculations);
    await repository.markCompleted(1, RecipeTaskId.result);

    await repository.discard(
      1,
      [RecipeTaskId.calculations, RecipeTaskId.result],
    );

    final ids = (await repository.listForRealization(1)).map((r) => r.taskId);
    expect(ids, equals([RecipeTaskId.prepareFruit]));
  });

  test('discard does not touch other realizations', () async {
    await repository.markCompleted(1, RecipeTaskId.prepareFruit);
    await repository.markCompleted(2, RecipeTaskId.prepareFruit);

    await repository.discard(1, [RecipeTaskId.prepareFruit]);

    expect(await repository.listForRealization(2), hasLength(1));
  });

  test('deleteAllFor clears only the given realization', () async {
    await repository.markCompleted(1, RecipeTaskId.prepareFruit);
    await repository.markCompleted(1, RecipeTaskId.calculations);
    await repository.markCompleted(2, RecipeTaskId.prepareFruit);

    await repository.deleteAllFor(1);

    expect(await repository.listForRealization(1), isEmpty);
    expect(await repository.listForRealization(2), hasLength(1));
  });

  test('watchForRealization emits the current rows', () async {
    await repository.markCompleted(1, RecipeTaskId.prepareFruit);

    final rows = await repository.watchForRealization(1).first;
    expect(rows, hasLength(1));
    expect(rows.single.taskId, equals(RecipeTaskId.prepareFruit));
  });
}
