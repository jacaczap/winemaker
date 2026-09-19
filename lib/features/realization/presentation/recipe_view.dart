import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winemaker/app/router.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/realization/domain/recipe_realization.dart';
import 'package:winemaker/features/realization/domain/task_state.dart';
import 'package:winemaker/features/realization/domain/task_timing.dart';
import 'package:winemaker/features/realization/presentation/progress.dart';
import 'package:winemaker/features/realization/presentation/realization_completed_dialog.dart';
import 'package:winemaker/features/realization/presentation/recipe_realization_controller.dart';
import 'package:winemaker/features/realization/presentation/realization_name_dialog.dart';
import 'package:winemaker/features/realization/presentation/task_row.dart';
import 'package:winemaker/features/realization/presentation/task_timing_summary.dart';
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
    final notifier =
        ref.read(recipeRealizationControllerProvider(realizationId).notifier);
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
    final action = await showRealizationCompletedDialog(context);
    if (action == null || !context.mounted) return;
    switch (action) {
      case RealizationCompletedAction.backToList:
        context.goNamed(AppRoute.home);
      case RealizationCompletedAction.showSummary:
        context.pushReplacementNamed(
          AppRoute.realizationSummary,
          pathParameters: {AppRoute.realizationIdParam: '$realizationId'},
        );
    }
  }

  Future<void> _rename(
    BuildContext context,
    WidgetRef ref,
    RecipeRealization realization,
  ) async {
    final name = await showRealizationNameDialog(
      context,
      currentName: realization.displayName(AppLocalizations.of(context)),
    );
    if (name == null) return;
    await ref
        .read(recipeRealizationControllerProvider(realizationId).notifier)
        .rename(name);
  }
}

class _RecipeBody extends ConsumerStatefulWidget {
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
  ConsumerState<_RecipeBody> createState() => _RecipeBodyState();
}

class _RecipeBodyState extends ConsumerState<_RecipeBody> {
  /// Tiles are uniform, so a constant is enough to land near the current task
  /// while its tile is still outside the list's build window.
  static const _estimatedTileExtent = 92.0;
  static const _maxScrollAttempts = 3;

  final _currentTaskKey = GlobalKey();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollToCurrentTask(animate: false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_RecipeBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.realization.currentTask != oldWidget.realization.currentTask) {
      _scrollToCurrentTask();
    }
  }

  void _scrollToCurrentTask({bool animate = true, int attempt = 0}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final tileContext = _currentTaskKey.currentContext;
      if (tileContext == null) {
        if (attempt >= _maxScrollAttempts) return;
        _jumpNearCurrentTask();
        _scrollToCurrentTask(animate: animate, attempt: attempt + 1);
        return;
      }
      Scrollable.ensureVisible(
        tileContext,
        alignment: 0.5,
        duration: animate ? const Duration(milliseconds: 400) : Duration.zero,
        curve: Curves.easeInOut,
      );
    });
  }

  void _jumpNearCurrentTask() {
    if (!_scrollController.hasClients) return;
    final maxOffset = _scrollController.position.maxScrollExtent;
    final target = widget.realization.currentTask * _estimatedTileExtent;
    _scrollController.jumpTo(target.clamp(0.0, maxOffset));
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.realization.recipe.getRecipe().tasks;
    final currentTaskIndex = widget.realization.currentTask;
    final l10n = AppLocalizations.of(context);
    final states =
        ref.watch(taskStatesProvider(widget.realizationId)).value ?? const {};

    return Column(
      children: [
        RecipeProgressHeader(
          totalNumberOfTasks: tasks.length,
          numberOfCompletedTasks: currentTaskIndex,
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(top: 4, bottom: 24),
            itemCount: tasks.length,
            itemBuilder: (context, index) => _buildTaskTile(
              l10n,
              tasks[index],
              index,
              currentTaskIndex,
              states,
            ),
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
    Map<RecipeTaskId, TaskStateRecord> states,
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
    final timing = taskTimingOf(
      tasks: widget.realization.recipe.getRecipe().tasks,
      states: states,
      taskId: task.id,
      realizationStart: widget.realization.startTime,
    );
    return TaskTile(
      key: status == TaskStatus.current ? _currentTaskKey : null,
      label: task.id.displayName(l10n),
      icon: task.type.icon,
      taskRouteName: task.type.routeName,
      realizationId: widget.realizationId,
      status: status,
      onCompleted: widget.onTaskComplete,
      onRedo: () => widget.onTaskRedo(index),
      routeExtra: _routeExtra(l10n, task, index, readOnly: isCompleted),
      completionLabel: timing.completedAt == null
          ? null
          : formatCompletion(l10n, timing, withTime: false),
      hasNote: states[task.id]?.notes?.isNotEmpty ?? false,
    );
  }

  Object? _routeExtra(
    AppLocalizations l10n,
    Task task,
    int index, {
    required bool readOnly,
  }) {
    final tasks = widget.realization.recipe.getRecipe().tasks;
    switch (task.type) {
      case TaskType.description:
        return DescriptionScreenArgs(
          title: task.id.displayName(l10n),
          taskId: task.id,
          markdown: task.id.description(l10n) ?? '',
          readOnly: readOnly,
        );
      case TaskType.initialMeasurement:
        return InitialMeasurementScreenArgs(
          title: task.id.displayName(l10n),
          taskId: task.id,
          description: task.id.description(l10n) ?? '',
          readOnly: readOnly,
        );
      case TaskType.calculations:
        return CalculationsScreenArgs(
          title: task.id.displayName(l10n),
          taskId: task.id,
          description: task.id.description(l10n) ?? '',
          sweetnessTaskId: _lastTaskIdBefore(
            tasks,
            index,
            TaskType.initialMeasurement,
          ),
          readOnly: readOnly,
        );
      case TaskType.result:
        return ResultScreenArgs(
          title: task.id.displayName(l10n),
          taskId: task.id,
          readOnly: readOnly,
        );
      case TaskType.timeNotification:
        final notification = task.notification;
        return TimeNotificationScreenArgs(
          title: task.id.displayName(l10n),
          taskId: task.id,
          description: task.id.description(l10n) ?? '',
          delay: notification?.delay ?? Duration.zero,
          postpone: notification?.postpone ?? Duration.zero,
          readOnly: readOnly,
        );
      case TaskType.addingIngredients:
        return AddingIngredientsScreenArgs(
          title: task.id.displayName(l10n),
          taskId: task.id,
          description: task.id.description(l10n) ?? '',
          ingredients: task.ingredients,
          calculationsTaskId:
              _lastTaskIdBefore(tasks, index, TaskType.calculations),
          priorIngredientTaskIds: [
            for (var i = 0; i < index; i++)
              if (tasks[i].type == TaskType.addingIngredients) tasks[i].id,
          ],
          readOnly: readOnly,
        );
    }
  }

  RecipeTaskId? _lastTaskIdBefore(List<Task> tasks, int index, TaskType type) {
    for (var i = index - 1; i >= 0; i--) {
      if (tasks[i].type == type) return tasks[i].id;
    }
    return null;
  }
}
