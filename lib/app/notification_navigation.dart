import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winemaker/app/router.dart';
import 'package:winemaker/core/l10n/system_localizations.dart';
import 'package:winemaker/core/notifications/notification_service.dart';
import 'package:winemaker/features/realization/data/recipe_realization_repository.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/features/recipe/domain/task_type.dart';

/// Opens the `timeNotification` step a tapped reminder points at.
///
/// Rebuilds the step's screen arguments from the realization's recipe (the
/// reminder only stores ids). Navigates to the nested route so the realization
/// view sits underneath and Back returns to it. No-op if the realization is
/// gone or the target is no longer a `timeNotification` task.
Future<void> openTaskFromNotification(
  ProviderContainer container,
  ReminderTarget target,
) async {
  final realization = await container
      .read(recipeRealizationRepositoryProvider)
      .byId(target.realizationId);
  if (realization == null) return;
  final tasks = realization.recipe.getRecipe().tasks;
  if (target.taskIndex < 0 || target.taskIndex >= tasks.length) return;
  final task = tasks[target.taskIndex];
  if (task.type != TaskType.timeNotification) return;
  final notification = task.notification;
  final l10n = systemAppLocalizations();
  appRouter.goNamed(
    AppRoute.timeNotification,
    pathParameters: {
      AppRoute.realizationIdParam: '${target.realizationId}',
    },
    extra: TimeNotificationScreenArgs(
      title: task.id.name(l10n),
      taskIndex: target.taskIndex,
      description: task.id.description(l10n) ?? '',
      delay: notification?.delay ?? Duration.zero,
      postpone: notification?.postpone ?? Duration.zero,
      readOnly: realization.currentTask > target.taskIndex,
    ),
  );
}
