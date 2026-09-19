import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/core/notifications/notification_service.dart';
import 'package:winemaker/features/realization/data/recipe_realization_repository.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/main.dart';

import '../../helpers/test_database.dart';

/// A completed realization opens as a journal: steps grouped by day, with the
/// waits between them called out.
void main() {
  testWidgets('a completed realization opens its summary', (tester) async {
    final db = MyDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        notificationServiceProvider
            .overrideWithValue(FakeNotificationService()),
      ],
    );
    addTearDown(container.dispose);

    final tasks = redWineRecipe.tasks;
    final realizations = container.read(recipeRealizationRepositoryProvider);
    final states = container.read(taskStateRepositoryProvider);
    final id = await realizations.create(AvailableRecipes.redWine);
    await states.markCompleted(
      id,
      tasks[0].id,
      completedAt: DateTime(2026, 3, 1, 10),
    );
    await states.saveNotes(id, tasks[0].id, 'plums from the garden');
    await states.markCompleted(
      id,
      tasks[1].id,
      completedAt: DateTime(2026, 3, 1, 18),
    );
    await states.markCompleted(
      id,
      tasks[2].id,
      completedAt: DateTime(2026, 3, 25, 9),
    );
    await realizations.updateCurrentTask(id, 3, completed: true);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MyApp()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Red Wine'));
    await tester.pumpAndSettle();

    expect(find.text('1 Mar 2026'), findsOneWidget);
    expect(find.text('25 Mar 2026'), findsOneWidget);
    expect(find.text('24 days'), findsOneWidget);
    expect(find.text('plums from the garden'), findsOneWidget);
    expect(find.textContaining('Started '), findsOneWidget);

    await tester.tap(find.byTooltip('Edit realization'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Rename'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
