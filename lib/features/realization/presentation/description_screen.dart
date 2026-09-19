import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/realization/domain/task_screen_result.dart';
import 'package:winemaker/features/realization/presentation/redo_from_here_button.dart';
import 'package:winemaker/features/realization/presentation/task_footer.dart';
import 'package:winemaker/features/recipe/domain/task.dart';
import 'package:winemaker/l10n/app_localizations.dart';

class DescriptionScreen extends ConsumerWidget {
  const DescriptionScreen({
    super.key,
    required this.realizationId,
    required this.taskId,
    required this.title,
    required this.markdown,
    this.readOnly = false,
  });

  final int realizationId;
  final RecipeTaskId taskId;
  final String title;
  final String markdown;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Markdown(
                padding: const EdgeInsets.all(16),
                data: markdown,
                selectable: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TaskFooter(realizationId: realizationId, taskId: taskId),
                  const SizedBox(height: 16),
                  if (readOnly)
                    RedoFromHereButton(
                      onPressed: () => context.pop(TaskScreenResult.redo),
                    )
                  else
                    FilledButton.icon(
                      onPressed: () => _complete(context, ref),
                      icon: const Icon(Icons.check),
                      label: Text(AppLocalizations.of(context).markAsDone),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _complete(BuildContext context, WidgetRef ref) async {
    await ref
        .read(taskStateRepositoryProvider)
        .markCompleted(realizationId, taskId);
    if (!context.mounted) return;
    context.pop(TaskScreenResult.completed);
  }
}
