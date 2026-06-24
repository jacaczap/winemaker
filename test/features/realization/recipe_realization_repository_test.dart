import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/features/realization/data/recipe_realization_repository.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/l10n/app_localizations.dart';

import '../../helpers/test_database.dart';

void main() {
  late MyDatabase db;
  late RecipeRealizationRepository repository;

  setUp(() {
    db = createTestDatabase();
    repository = RecipeRealizationRepository(db);
  });

  tearDown(() => db.close());

  test('create assigns sequential ids starting at 1', () async {
    final first = await repository.create(AvailableRecipes.redWine);
    final second = await repository.create(AvailableRecipes.redWine);

    expect(first, equals(1));
    expect(second, equals(2));
  });

  test('byId returns the stored realization and null when absent', () async {
    final id = await repository.create(AvailableRecipes.redWine);

    final found = await repository.byId(id);
    expect(found, isNotNull);
    expect(found!.id, equals(id));
    expect(found.recipe, equals(AvailableRecipes.redWine));
    expect(found.currentTask, equals(0));
    expect(found.completed, isFalse);

    expect(await repository.byId(999), isNull);
  });

  test('updateCurrentTask persists progress and completion', () async {
    final id = await repository.create(AvailableRecipes.redWine);

    await repository.updateCurrentTask(id, 4, completed: true);

    final updated = await repository.byId(id);
    expect(updated!.currentTask, equals(4));
    expect(updated.completed, isTrue);
  });

  test('updateCurrentTask leaves completion untouched when omitted', () async {
    final id = await repository.create(AvailableRecipes.redWine);
    await repository.updateCurrentTask(id, 2, completed: true);

    await repository.updateCurrentTask(id, 3);

    final updated = await repository.byId(id);
    expect(updated!.currentTask, equals(3));
    expect(updated.completed, isTrue);
  });

  test('byId falls back to recipe name until renamed', () async {
    final l10n = lookupAppLocalizations(const Locale('en'));
    final id = await repository.create(AvailableRecipes.redWine);

    final created = await repository.byId(id);
    expect(created!.name, isNull);
    expect(
      created.displayName(l10n),
      equals(AvailableRecipes.redWine.displayName(l10n)),
    );

    await repository.updateName(id, 'Grandpa batch');

    final renamed = await repository.byId(id);
    expect(renamed!.name, equals('Grandpa batch'));
    expect(renamed.displayName(l10n), equals('Grandpa batch'));
  });

  test('watchAll sorts in-progress first, then by most recent start', () async {
    await _insert(db, id: 1, completed: false, start: _at('2024-01-01'));
    await _insert(db, id: 2, completed: true, start: _at('2024-06-01'));
    await _insert(db, id: 3, completed: false, start: _at('2024-03-01'));

    final ordered = await repository.watchAll().first;

    expect(ordered.map((r) => r.id), equals([3, 1, 2]));
  });

  test('delete removes the realization and its task state', () async {
    final id = await repository.create(AvailableRecipes.redWine);
    await TaskStateRepository(db).markCompleted(id, 0);

    await repository.delete(id);

    expect(await repository.byId(id), isNull);
    expect(await TaskStateRepository(db).listForRealization(id), isEmpty);
  });
}

DateTime _at(String iso) => DateTime.parse(iso);

Future<void> _insert(
  MyDatabase db, {
  required int id,
  required bool completed,
  required DateTime start,
}) =>
    db.recipeRealizationDao.addRecipeRealization(
      RecipeRealizationEntityData(
        id: id,
        currentTask: 0,
        recipe: AvailableRecipes.redWine,
        startTime: start,
        completed: completed,
      ),
    );
