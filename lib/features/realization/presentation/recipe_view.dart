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
          onTaskRevert: () => ref
              .read(recipeRealizationControllerProvider(realizationId).notifier)
              .revertCurrentTask(),
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
    required this.onTaskRevert,
  });

  final int realizationId;
  final RecipeRealization realization;
  final VoidCallback onTaskComplete;
  final VoidCallback onTaskRevert;

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
    return TaskTile(
      label: task.name,
      icon: task.type.icon,
      taskRouteName: task.type.routeName,
      realizationId: realizationId,
      status: status,
      canRevert: index == currentTaskIndex - 1,
      onCompleted: onTaskComplete,
      onRevert: onTaskRevert,
      routeExtra: _routeExtra(task, index),
    );
  }

  Object? _routeExtra(Task task, int index) {
    switch (task.type) {
      case TaskType.description:
        return DescriptionScreenArgs(
          title: task.name,
          markdown: task.description ?? '',
        );
      case TaskType.setup:
        return SetupScreenArgs(title: task.name, taskIndex: index);
      case TaskType.addingIngredients:
      case TaskType.timeNotification:
        return null;
    }
  }
}
