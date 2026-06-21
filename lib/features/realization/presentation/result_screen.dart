import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/realization/domain/result_payload.dart';
import 'package:winemaker/features/realization/domain/task_screen_result.dart';
import 'package:winemaker/features/realization/presentation/redo_from_here_button.dart';

/// Result task: free-text capture of how the wine turned out and any mistakes.
///
/// Persists a [ResultPayload] for its task occurrence and pops `true` so the
/// realization advances. Loads any previously saved text so the user can
/// re-edit it when revisiting the task.
class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({
    super.key,
    required this.realizationId,
    required this.taskIndex,
    required this.title,
    this.readOnly = false,
  });

  final int realizationId;
  final int taskIndex;
  final String title;
  final bool readOnly;

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  final _resultsController = TextEditingController();
  final _mistakesController = TextEditingController();

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  @override
  void dispose() {
    _resultsController.dispose();
    _mistakesController.dispose();
    super.dispose();
  }

  Future<void> _loadExisting() async {
    final record = await ref
        .read(taskStateRepositoryProvider)
        .get(widget.realizationId, widget.taskIndex);
    if (!mounted) return;
    final json = record?.payloadJson;
    if (json != null) {
      final payload = ResultPayload.fromJson(json);
      _resultsController.text = payload.results;
      _mistakesController.text = payload.mistakes;
    }
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final payload = ResultPayload(
      results: _resultsController.text.trim(),
      mistakes: _mistakesController.text.trim(),
    );
    await ref.read(taskStateRepositoryProvider).markCompleted(
          widget.realizationId,
          widget.taskIndex,
          payload: payload,
        );
    if (!mounted) return;
    context.pop(TaskScreenResult.completed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(child: _buildForm(context)),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ResultField(
            controller: _resultsController,
            label: 'Results',
            hint: 'How did the wine turn out? Taste, clarity, strength…',
            enabled: !widget.readOnly,
          ),
          const SizedBox(height: 24),
          _ResultField(
            controller: _mistakesController,
            label: 'Mistakes',
            hint: 'Anything to do differently next time?',
            enabled: !widget.readOnly,
          ),
          const SizedBox(height: 24),
          if (widget.readOnly)
            RedoFromHereButton(
              onPressed: () => context.pop(TaskScreenResult.redo),
            )
          else
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.check),
              label: const Text('Save & mark done'),
            ),
        ],
      ),
    );
  }
}

class _ResultField extends StatelessWidget {
  const _ResultField({
    required this.controller,
    required this.label,
    required this.hint,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.multiline,
      minLines: 3,
      maxLines: 8,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: true,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
