import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/core/notifications/notification_service.dart';
import 'package:winemaker/features/realization/data/recipe_realization_repository.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/realization/domain/result_payload.dart';
import 'package:winemaker/features/realization/presentation/recipe_realization_controller.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/features/recipe/domain/task_type.dart';

import '../../helpers/test_database.dart';

void main() {
  late MyDatabase db;
  late FakeNotificationService notifications;
  late ProviderContainer container;

  setUp(() {
    db = createTestDatabase();
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

  final lastTaskIndex = redWineRecipe.tasks.length - 1;

  Future<int> seedRealization({int? currentTask, bool completed = false}) async {
    final repository = container.read(recipeRealizationRepositoryProvider);
    final id = await repository.create(AvailableRecipes.redWine);
    if (currentTask != null) {
      await repository.updateCurrentTask(id, currentTask, completed: completed);
    }
    return id;
  }

  test('build throws when the realization does not exist', () async {
    expect(
      () => container.read(recipeRealizationControllerProvider(999).future),
      throwsA(isA<StateError>()),
    );
  });

  test('completeCurrentTask advances the current task by one', () async {
    final id = await seedRealization();
    await container.read(recipeRealizationControllerProvider(id).future);

    await container
        .read(recipeRealizationControllerProvider(id).notifier)
        .completeCurrentTask();

    final state = container.read(recipeRealizationControllerProvider(id)).value!;
    expect(state.currentTask, equals(1));
    expect(state.completed, isFalse);
  });

  test('completing the final task auto-completes the realization', () async {
    final id = await seedRealization(currentTask: lastTaskIndex);
    await container.read(recipeRealizationControllerProvider(id).future);

    await container
        .read(recipeRealizationControllerProvider(id).notifier)
        .completeCurrentTask();

    final state = container.read(recipeRealizationControllerProvider(id)).value!;
    expect(state.currentTask, equals(redWineRecipe.tasks.length));
    expect(state.completed, isTrue);
  });

  test('completeCurrentTask is a no-op once the recipe is finished', () async {
    final id = await seedRealization(
      currentTask: redWineRecipe.tasks.length,
      completed: true,
    );
    await container.read(recipeRealizationControllerProvider(id).future);

    await container
        .read(recipeRealizationControllerProvider(id).notifier)
        .completeCurrentTask();

    final state = container.read(recipeRealizationControllerProvider(id)).value!;
    expect(state.currentTask, equals(redWineRecipe.tasks.length));
  });

  test('jumpToTask resets the pointer, discards later data and cancels reminders',
      () async {
    final id = await seedRealization(currentTask: lastTaskIndex);
    final tasks = redWineRecipe.tasks;
    final taskStates = container.read(taskStateRepositoryProvider);
    await taskStates.markCompleted(id, tasks[0].id);
    await taskStates.markCompleted(id, tasks[2].id);
    await taskStates.markCompleted(id, tasks[5].id);
    await taskStates.markCompleted(
      id,
      tasks[lastTaskIndex].id,
      payload: const ResultPayload(results: 'great', mistakes: 'none'),
    );
    await container.read(recipeRealizationControllerProvider(id).future);

    await container
        .read(recipeRealizationControllerProvider(id).notifier)
        .jumpToTask(2);

    final state = container.read(recipeRealizationControllerProvider(id)).value!;
    expect(state.currentTask, equals(2));
    expect(state.completed, isFalse);

    final remaining = await taskStates.listForRealization(id);
    expect(
      remaining.map((r) => r.taskId),
      unorderedEquals([tasks[0].id, tasks[2].id]),
    );

    final cancelledWaits = [
      for (final task in tasks.skip(3))
        if (task.type == TaskType.timeNotification) task.id.name,
    ];
    expect(
      notifications.cancelled.map((c) => c.$2),
      containsAll(cancelledWaits),
    );
  });

  test('jumpToTask ignores forward jumps', () async {
    final id = await seedRealization(currentTask: 3);
    await container.read(recipeRealizationControllerProvider(id).future);

    await container
        .read(recipeRealizationControllerProvider(id).notifier)
        .jumpToTask(5);

    final state = container.read(recipeRealizationControllerProvider(id)).value!;
    expect(state.currentTask, equals(3));
    expect(notifications.cancelled, isEmpty);
  });
}
