import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:winemaker/app/router.dart';
import 'package:winemaker/features/realization/domain/task_screen_result.dart';

enum TaskStatus { completed, current, pending }

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.label,
    required this.icon,
    required this.taskRouteName,
    required this.realizationId,
    required this.status,
    required this.onCompleted,
    required this.onRedo,
    this.routeExtra,
  });

  final String label;
  final IconData icon;
  final String taskRouteName;
  final int realizationId;
  final TaskStatus status;
  final VoidCallback onCompleted;
  final VoidCallback onRedo;
  final Object? routeExtra;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isCurrent = status == TaskStatus.current;
    final isCompleted = status == TaskStatus.completed;

    final tileBackground = isCurrent
        ? colors.primaryContainer
        : isCompleted
            ? colors.surfaceContainerHighest
            : colors.surface;
    final foreground = isCurrent
        ? colors.onPrimaryContainer
        : isCompleted
            ? colors.onSurfaceVariant
            : colors.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: tileBackground,
        elevation: isCurrent ? 2 : 0,
        shadowColor: colors.shadow,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _onTap(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _Leading(icon: icon, status: status, foreground: foreground),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: foreground,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _statusLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: foreground.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                _Trailing(status: status, foreground: foreground),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get _statusLabel {
    switch (status) {
      case TaskStatus.completed:
        return 'Completed - tap to view';
      case TaskStatus.current:
        return 'Tap to start';
      case TaskStatus.pending:
        return 'Pending';
    }
  }

  VoidCallback? _onTap(BuildContext context) {
    switch (status) {
      case TaskStatus.current:
      case TaskStatus.completed:
        return () => _navigateToTask(context);
      case TaskStatus.pending:
        return null;
    }
  }

  Future<void> _navigateToTask(BuildContext context) async {
    final result = await context.pushNamed<TaskScreenResult>(
      taskRouteName,
      pathParameters: {AppRoute.realizationIdParam: realizationId.toString()},
      extra: routeExtra,
    );
    if (!context.mounted) return;
    switch (result) {
      case TaskScreenResult.completed:
        onCompleted();
      case TaskScreenResult.redo:
        await _confirmRedo(context);
      case null:
        break;
    }
  }

  Future<void> _confirmRedo(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Redo from here?'),
        content: Text(
          'Go back to "$label" and redo from there? Data entered in later '
          'tasks will be discarded.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Redo'),
          ),
        ],
      ),
    );
    if (confirmed == true) onRedo();
  }
}

class _Leading extends StatelessWidget {
  const _Leading({
    required this.icon,
    required this.status,
    required this.foreground,
  });

  final IconData icon;
  final TaskStatus status;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final background = switch (status) {
      TaskStatus.current => colors.primary,
      TaskStatus.completed => colors.primary.withValues(alpha: 0.12),
      TaskStatus.pending => colors.surfaceContainerHighest,
    };
    final iconColor = switch (status) {
      TaskStatus.current => colors.onPrimary,
      TaskStatus.completed => colors.primary,
      TaskStatus.pending => colors.onSurfaceVariant,
    };
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: iconColor),
    );
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({required this.status, required this.foreground});

  final TaskStatus status;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case TaskStatus.completed:
        return Icon(Icons.check_circle, color: foreground);
      case TaskStatus.current:
        return Icon(Icons.arrow_forward_rounded, color: foreground);
      case TaskStatus.pending:
        return Icon(
          Icons.lock_outline,
          color: foreground.withValues(alpha: 0.5),
        );
    }
  }
}
