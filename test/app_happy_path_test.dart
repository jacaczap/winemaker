import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/core/notifications/notification_service.dart';
import 'package:winemaker/features/realization/presentation/recipe_realization_controller.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/main.dart';

import 'helpers/test_database.dart';

/// Happy path: browse a recipe, then run a realization to completion.
///
/// Completion is driven through the controller to keep the test independent of
/// each task screen's input flow.
void main() {
  testWidgets('browse a recipe and run a realization to completion',
      (tester) async {
    final db = MyDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        notificationServiceProvider.overrideWithValue(FakeNotificationService()),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MyApp()),
    );
    await tester.pumpAndSettle();
    expect(find.text('No realizations yet'), findsOneWidget);

    await tester.tap(find.byTooltip('Recipes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Red Wine'));
    await tester.pumpAndSettle();
    expect(find.text('Prepare the fruit'), findsOneWidget);
    expect(find.text('Calculations'), findsWidgets);

    await tester.tap(find.byType(BackButton).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton).first);
    await tester.pumpAndSettle();

    final id = await container
        .read(recipeRealizationsControllerProvider.notifier)
        .create(AvailableRecipes.redWine);
    final subscription = container.listen(
      recipeRealizationControllerProvider(id),
      (_, __) {},
    );
    addTearDown(subscription.close);
    await container.read(recipeRealizationControllerProvider(id).future);
    final notifier =
        container.read(recipeRealizationControllerProvider(id).notifier);
    for (var i = 0; i < redWineRecipe.tasks.length; i++) {
      await notifier.completeCurrentTask();
    }
    await tester.pumpAndSettle();

    expect(
      container.read(recipeRealizationControllerProvider(id)).value!.completed,
      isTrue,
    );
    expect(find.text('Red Wine'), findsOneWidget);
    expect(find.textContaining('Completed'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
