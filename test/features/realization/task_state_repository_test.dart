import 'package:flutter_test/flutter_test.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/realization/domain/result_payload.dart';
import 'package:winemaker/features/realization/domain/task_state.dart';

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
    expect(await repository.get(1, 0), isNull);
  });

  test('savePending stores a pending record without payload', () async {
    await repository.savePending(1, 0);

    final record = await repository.get(1, 0);
    expect(record, isNotNull);
    expect(record!.status, equals(TaskState.pending));
    expect(record.payloadJson, isNull);
  });

  test('markCompleted round-trips the payload as JSON', () async {
    await repository.markCompleted(
      1,
      2,
      payload: const ResultPayload(results: 'clean', mistakes: 'added late'),
    );

    final record = await repository.get(1, 2);
    expect(record!.status, equals(TaskState.completed));

    final payload = ResultPayload.fromJson(record.payloadJson!);
    expect(payload.results, equals('clean'));
    expect(payload.mistakes, equals('added late'));
  });

  test('upsert overwrites the previous row for the same key', () async {
    await repository.savePending(1, 0);
    await repository.markCompleted(1, 0);

    final all = await repository.listForRealization(1);
    expect(all, hasLength(1));
    expect(all.single.status, equals(TaskState.completed));
  });

  test('listForRealization returns rows ordered by task index', () async {
    await repository.markCompleted(1, 2);
    await repository.markCompleted(1, 0);
    await repository.markCompleted(1, 1);

    final indices =
        (await repository.listForRealization(1)).map((r) => r.taskIndex);

    expect(indices, equals([0, 1, 2]));
  });

  test('discardAfter keeps the target and deletes strictly later rows',
      () async {
    for (var i = 0; i < 4; i++) {
      await repository.markCompleted(1, i);
    }

    await repository.discardAfter(1, 1);

    final indices =
        (await repository.listForRealization(1)).map((r) => r.taskIndex);
    expect(indices, equals([0, 1]));
  });

  test('discardAfter does not touch other realizations', () async {
    await repository.markCompleted(1, 0);
    await repository.markCompleted(2, 5);

    await repository.discardAfter(1, 0);

    expect(await repository.listForRealization(2), hasLength(1));
  });

  test('deleteAllFor clears only the given realization', () async {
    await repository.markCompleted(1, 0);
    await repository.markCompleted(1, 1);
    await repository.markCompleted(2, 0);

    await repository.deleteAllFor(1);

    expect(await repository.listForRealization(1), isEmpty);
    expect(await repository.listForRealization(2), hasLength(1));
  });

  test('watchForRealization emits the current rows', () async {
    await repository.markCompleted(1, 0);

    final rows = await repository.watchForRealization(1).first;
    expect(rows, hasLength(1));
    expect(rows.single.taskIndex, equals(0));
  });
}
