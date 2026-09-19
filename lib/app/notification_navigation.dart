import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winemaker/app/router.dart';
import 'package:winemaker/core/l10n/system_localizations.dart';
import 'package:winemaker/core/notifications/notification_service.dart';
import 'package:winemaker/features/realization/data/recipe_realization_repository.dart';
import 'package:winemaker/features/realization/domain/task_screen_result.dart';
import 'package:winemaker/features/realization/presentation/recipe_realization_controller.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/features/recipe/domain/task_type.dart';

/// Opens the `timeNotification` step a tapped reminder points at.
///
/// Rebuilds the step's screen arguments from the realization's recipe (the
/// reminder only stores ids) and pushes it on top of the realization view, so
/// Back returns there and completing the wait advances the realization exactly
/// like completing it from the task list. A stale reminder — realization gone,
/// target no longer a wait, or the step no longer the current one — only opens
/// the realization.
Future<void> openTaskFromNotification(
  ProviderContainer container,
  ReminderTarget target,
) async {
  final realization = await container
      .read(recipeRealizationRepositoryProvider)
      .byId(target.realizationId);
  if (realization == null) return;
  final tasks = realization.recipe.getRecipe().tasks;
  final index = tasks.indexWhere((t) => t.id.name == target.taskKey);
  if (index < 0) return;
  final pathParameters = {
    AppRoute.realizationIdParam: '${target.realizationId}',
  };
  appRouter.goNamed(AppRoute.recipe, pathParameters: pathParameters);
  final task = tasks[index];
  if (task.type != TaskType.timeNotification ||
      realization.currentTask != index) {
    return;
  }
  final notification = task.notification;
  final l10n = systemAppLocalizations();
  final result = await appRouter.pushNamed<TaskScreenResult>(
    AppRoute.timeNotification,
    pathParameters: pathParameters,
    extra: TimeNotificationScreenArgs(
      title: task.id.displayName(l10n),
      taskId: task.id,
      description: task.id.description(l10n) ?? '',
      delay: notification?.delay ?? Duration.zero,
      postpone: notification?.postpone ?? Duration.zero,
    ),
  );
  if (result != TaskScreenResult.completed) return;
  final controller = recipeRealizationControllerProvider(target.realizationId);
  await container.read(controller.future);
  await container.read(controller.notifier).completeCurrentTask();
}
