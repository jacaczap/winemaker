import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/core/notifications/notification_service.dart';
import 'package:winemaker/features/realization/presentation/recipe_realization_controller.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/main.dart';

import '../../helpers/test_database.dart';

/// A realization is also a record: steps take a note and remember when they
/// were done.
void main() {
  testWidgets('a step keeps a note and shows when it was completed',
      (tester) async {
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

    await container
        .read(recipeRealizationsControllerProvider.notifier)
        .create(AvailableRecipes.redWine);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MyApp()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Red Wine'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Prepare the fruit'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add note'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'plums from the garden');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save note'));
    await tester.pumpAndSettle();
    expect(find.text('Save note'), findsNothing);

    await tester.tap(find.text('Mark as done'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.sticky_note_2_outlined), findsOneWidget);
    expect(find.textContaining('Completed '), findsOneWidget);

    await tester.tap(find.text('Prepare the fruit'));
    await tester.pumpAndSettle();
    expect(find.text('plums from the garden'), findsOneWidget);
    expect(find.text('Redo from here'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
