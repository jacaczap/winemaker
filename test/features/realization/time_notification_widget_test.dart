import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:winemaker/app/notification_navigation.dart';
import 'package:winemaker/app/router.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/core/notifications/notification_service.dart';
import 'package:winemaker/features/realization/data/recipe_realization_repository.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/realization/domain/time_notification_payload.dart';
import 'package:winemaker/features/realization/presentation/recipe_realization_controller.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/main.dart';

import '../../helpers/test_database.dart';

/// Waiting steps own a phone reminder, so every way in and out of them has to
/// keep that reminder in sync with the realization's progress.
void main() {
  const waitIndex = 3;
  final waitTask = redWineRecipe.tasks[waitIndex];

  late MyDatabase db;
  late FakeNotificationService notifications;
  late ProviderContainer container;

  setUp(() {
    db = MyDatabase.forTesting(NativeDatabase.memory());
    notifications = FakeNotificationService();
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        notificationServiceProvider.overrideWithValue(notifications),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<int> seedAtWait() async {
    final repository = container.read(recipeRealizationRepositoryProvider);
    final id = await repository.create(AvailableRecipes.redWine);
    await repository.updateCurrentTask(id, waitIndex, completed: false);
    return id;
  }

  Future<void> pumpApp(WidgetTester tester) async {
    appRouter.go('/');
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MyApp()),
    );
    await tester.pumpAndSettle();
  }

  Future<void> disposeApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  }

  /// The wait screen ticks every second, so it never settles.
  Future<void> pumpFrames(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 20));
    }
  }

  testWidgets('completing a wait from a tapped reminder advances the recipe',
      (tester) async {
    final id = await seedAtWait();
    await pumpApp(tester);

    final tapped = openTaskFromNotification(
      container,
      (realizationId: id, taskKey: waitTask.id.name),
    );
    await pumpFrames(tester);
    expect(find.text('Complete now'), findsOneWidget);

    await tester.tap(find.text('Complete now'));
    await pumpFrames(tester);
    await tapped;

    expect(notifications.cancelled, contains((id, waitTask.id.name)));
    final state =
        container.read(recipeRealizationControllerProvider(id)).value!;
    expect(state.currentTask, equals(waitIndex + 1));

    await disposeApp(tester);
  });

  testWidgets('redoing a finished wait starts a fresh countdown',
      (tester) async {
    final id = await seedAtWait();
    await container.read(taskStateRepositoryProvider).markCompleted(
          id,
          waitTask.id,
          payload: TimeNotificationPayload(
            scheduledFor: DateTime.now().subtract(const Duration(days: 30)),
          ),
        );
    await container
        .read(recipeRealizationRepositoryProvider)
        .updateCurrentTask(id, waitIndex + 1, completed: false);
    await pumpApp(tester);
    await tester.tap(find.text('Red Wine'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ferment with the skins'));
    await pumpFrames(tester);
    await tester.tap(find.text('Redo from here'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Redo'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ferment with the skins'));
    await pumpFrames(tester);

    expect(find.text('Ready to continue'), findsNothing);
    final scheduledFor = notifications.scheduled
        .lastWhere((reminder) => reminder.$2 == waitTask.id.name)
        .$3;
    expect(
      scheduledFor.isAfter(DateTime.now().add(const Duration(days: 6))),
      isTrue,
    );

    await disposeApp(tester);
  });
}
