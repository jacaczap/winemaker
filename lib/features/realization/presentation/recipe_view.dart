import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winemaker/app/router.dart';
import 'package:winemaker/features/realization/domain/recipe_realization.dart';
import 'package:winemaker/features/realization/presentation/progress.dart';
import 'package:winemaker/features/realization/presentation/recipe_realization_controller.dart';
import 'package:winemaker/features/realization/presentation/task_row.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/features/recipe/domain/task.dart';
import 'package:winemaker/features/recipe/domain/task_type.dart';

class RecipeViewWrapper extends ConsumerWidget {
  const RecipeViewWrapper({super.key, required this.realizationId});

  final int realizationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final realization = ref.watch(
      recipeRealizationControllerProvider(realizationId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(realization.maybeWhen(
          data: (data) => data.recipe.displayName,
          orElse: () => 'Recipe',
        )),
      ),
      body: realization.when(
        data: (data) => _RecipeBody(
          realizationId: realizationId,
          realization: data,
          onTaskComplete: () => ref
              .read(recipeRealizationControllerProvider(realizationId).notifier)
              .completeCurrentTask(),
          onTaskRedo: (index) => ref
              .read(recipeRealizationControllerProvider(realizationId).notifier)
              .jumpToTask(index),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _RecipeBody extends StatelessWidget {
  const _RecipeBody({
    required this.realizationId,
    required this.realization,
    required this.onTaskComplete,
    required this.onTaskRedo,
  });

  final int realizationId;
  final RecipeRealization realization;
  final VoidCallback onTaskComplete;
  final ValueChanged<int> onTaskRedo;

  @override
  Widget build(BuildContext context) {
    final tasks = realization.recipe.getRecipe().tasks;
    final currentTaskIndex = realization.currentTask;

    return Column(
      children: [
        RecipeProgressHeader(
          totalNumberOfTasks: tasks.length,
          numberOfCompletedTasks: currentTaskIndex,
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 4, bottom: 24),
            itemCount: tasks.length,
            itemBuilder: (context, index) =>
                _buildTaskTile(tasks[index], index, currentTaskIndex),
          ),
        ),
      ],
    );
  }

  TaskTile _buildTaskTile(Task task, int index, int currentTaskIndex) {
    final TaskStatus status;
    if (currentTaskIndex > index) {
      status = TaskStatus.completed;
    } else if (currentTaskIndex == index) {
      status = TaskStatus.current;
    } else {
      status = TaskStatus.pending;
    }
    final isCompleted = status == TaskStatus.completed;
    return TaskTile(
      label: task.name,
      icon: task.type.icon,
      taskRouteName: task.type.routeName,
      realizationId: realizationId,
      status: status,
      onCompleted: onTaskComplete,
      onRedo: () => onTaskRedo(index),
      routeExtra: _routeExtra(task, index, readOnly: isCompleted),
    );
  }

  Object? _routeExtra(Task task, int index, {required bool readOnly}) {
    switch (task.type) {
      case TaskType.description:
        return DescriptionScreenArgs(
          title: task.name,
          markdown: task.description ?? '',
          readOnly: readOnly,
        );
      case TaskType.calculations:
        return CalculationsScreenArgs(
          title: task.name,
          taskIndex: index,
          readOnly: readOnly,
        );
      case TaskType.result:
        return ResultScreenArgs(
          title: task.name,
          taskIndex: index,
          readOnly: readOnly,
        );
      case TaskType.timeNotification:
        final notification = task.notification;
        return TimeNotificationScreenArgs(
          title: task.name,
          taskIndex: index,
          description: task.description ?? '',
          delay: notification?.delay ?? Duration.zero,
          postpone: notification?.postpone ?? Duration.zero,
          readOnly: readOnly,
        );
      case TaskType.addingIngredients:
        final tasks = realization.recipe.getRecipe().tasks;
        return AddingIngredientsScreenArgs(
          title: task.name,
          taskIndex: index,
          description: task.description ?? '',
          calculationsTaskIndex: _lastCalculationsIndexBefore(tasks, index),
          priorIngredientTaskIndices: [
            for (var i = 0; i < index; i++)
              if (tasks[i].type == TaskType.addingIngredients) i,
          ],
          readOnly: readOnly,
        );
    }
  }

  int? _lastCalculationsIndexBefore(List<Task> tasks, int index) {
    for (var i = index - 1; i >= 0; i--) {
      if (tasks[i].type == TaskType.calculations) return i;
    }
    return null;
  }
}
