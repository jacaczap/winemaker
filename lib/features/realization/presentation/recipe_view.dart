import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winemaker/app/router.dart';
import 'package:winemaker/features/realization/domain/recipe_realization.dart';
import 'package:winemaker/features/realization/presentation/progress.dart';
import 'package:winemaker/features/realization/presentation/realization_completed_dialog.dart';
import 'package:winemaker/features/realization/presentation/recipe_realization_controller.dart';
import 'package:winemaker/features/realization/presentation/rename_realization_dialog.dart';
import 'package:winemaker/features/realization/presentation/task_row.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/features/recipe/domain/task.dart';
import 'package:winemaker/features/recipe/domain/task_type.dart';
import 'package:winemaker/l10n/app_localizations.dart';

class RecipeViewWrapper extends ConsumerWidget {
  const RecipeViewWrapper({super.key, required this.realizationId});

  final int realizationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final realization = ref.watch(
      recipeRealizationControllerProvider(realizationId),
    );

    final data = realization.value;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(data?.displayName(l10n) ?? l10n.recipeFallbackTitle),
        actions: [
          if (data != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: l10n.rename,
              onPressed: () => _rename(context, ref, data),
            ),
        ],
      ),
      body: realization.when(
        data: (data) => _RecipeBody(
          realizationId: realizationId,
          realization: data,
          onTaskComplete: () => _completeCurrentTask(context, ref),
          onTaskRedo: (index) => ref
              .read(recipeRealizationControllerProvider(realizationId).notifier)
              .jumpToTask(index),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(l10n.errorWithMessage(error))),
      ),
    );
  }

  Future<void> _completeCurrentTask(BuildContext context, WidgetRef ref) async {
    final notifier = ref
        .read(recipeRealizationControllerProvider(realizationId).notifier);
    final wasCompleted = ref
            .read(recipeRealizationControllerProvider(realizationId))
            .value
            ?.completed ??
        false;
    await notifier.completeCurrentTask();
    if (!context.mounted) return;
    final nowCompleted = ref
            .read(recipeRealizationControllerProvider(realizationId))
            .value
            ?.completed ??
        false;
    if (wasCompleted || !nowCompleted) return;
    final goToList = await showRealizationCompletedDialog(context);
    if (goToList && context.mounted) context.goNamed(AppRoute.home);
  }

  Future<void> _rename(
    BuildContext context,
    WidgetRef ref,
    RecipeRealization realization,
  ) async {
    final name = await showRenameRealizationDialog(
      context,
      currentName: realization.displayName(AppLocalizations.of(context)),
    );
    if (name == null) return;
    await ref
        .read(recipeRealizationControllerProvider(realizationId).notifier)
        .rename(name);
  }
}

class _RecipeBody extends StatefulWidget {
  const _RecipeBody({
    required this.realizationId,
    required this.realization,
    required this.onTaskComplete,
    required this.onTaskRedo,
  });

  final int realizationId;
  final RecipeRealization realization;
  final Future<void> Function() onTaskComplete;
  final ValueChanged<int> onTaskRedo;

  @override
  State<_RecipeBody> createState() => _RecipeBodyState();
}

class _RecipeBodyState extends State<_RecipeBody> {
  final _currentTaskKey = GlobalKey();

  @override
  void didUpdateWidget(_RecipeBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.realization.currentTask != oldWidget.realization.currentTask) {
      _scrollToCurrentTask();
    }
  }

  void _scrollToCurrentTask() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _currentTaskKey.currentContext;
      if (context == null) return;
      Scrollable.ensureVisible(
        context,
        alignment: 0.5,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.realization.recipe.getRecipe().tasks;
    final currentTaskIndex = widget.realization.currentTask;
    final l10n = AppLocalizations.of(context);

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
                _buildTaskTile(l10n, tasks[index], index, currentTaskIndex),
          ),
        ),
      ],
    );
  }

  TaskTile _buildTaskTile(
    AppLocalizations l10n,
    Task task,
    int index,
    int currentTaskIndex,
  ) {
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
      key: status == TaskStatus.current ? _currentTaskKey : null,
      label: task.id.name(l10n),
      icon: task.type.icon,
      taskRouteName: task.type.routeName,
      realizationId: widget.realizationId,
      status: status,
      onCompleted: widget.onTaskComplete,
      onRedo: () => widget.onTaskRedo(index),
      routeExtra: _routeExtra(l10n, task, index, readOnly: isCompleted),
    );
  }

  Object? _routeExtra(
    AppLocalizations l10n,
    Task task,
    int index, {
    required bool readOnly,
  }) {
    switch (task.type) {
      case TaskType.description:
        return DescriptionScreenArgs(
          title: task.id.name(l10n),
          markdown: task.id.description(l10n) ?? '',
          readOnly: readOnly,
        );
      case TaskType.calculations:
        return CalculationsScreenArgs(
          title: task.id.name(l10n),
          taskIndex: index,
          readOnly: readOnly,
        );
      case TaskType.result:
        return ResultScreenArgs(
          title: task.id.name(l10n),
          taskIndex: index,
          readOnly: readOnly,
        );
      case TaskType.timeNotification:
        final notification = task.notification;
        return TimeNotificationScreenArgs(
          title: task.id.name(l10n),
          taskIndex: index,
          description: task.id.description(l10n) ?? '',
          delay: notification?.delay ?? Duration.zero,
          postpone: notification?.postpone ?? Duration.zero,
          readOnly: readOnly,
        );
      case TaskType.addingIngredients:
        final tasks = widget.realization.recipe.getRecipe().tasks;
        return AddingIngredientsScreenArgs(
          title: task.id.name(l10n),
          taskIndex: index,
          description: task.id.description(l10n) ?? '',
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
