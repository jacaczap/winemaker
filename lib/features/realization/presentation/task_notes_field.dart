import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/recipe/domain/task.dart';
import 'package:winemaker/l10n/app_localizations.dart';

/// Free-text note attached to one task occurrence.
///
/// Collapsed until tapped, and auto-expanded when a note already exists. Saves
/// on its own button so a note can be added to an already completed task
/// without redoing it or changing its completion time.
class TaskNotesField extends ConsumerStatefulWidget {
  const TaskNotesField({
    super.key,
    required this.realizationId,
    required this.taskId,
  });

  final int realizationId;
  final RecipeTaskId taskId;

  @override
  ConsumerState<TaskNotesField> createState() => _TaskNotesFieldState();
}

class _TaskNotesFieldState extends ConsumerState<TaskNotesField> {
  final _controller = TextEditingController();

  String _saved = '';
  bool _expanded = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final record = await ref
        .read(taskStateRepositoryProvider)
        .get(widget.realizationId, widget.taskId);
    if (!mounted) return;
    final notes = record?.notes ?? '';
    setState(() {
      _saved = notes;
      _controller.text = notes;
      _expanded = notes.isNotEmpty;
    });
  }

  Future<void> _save() async {
    final notes = _controller.text.trim();
    setState(() => _saving = true);
    await ref
        .read(taskStateRepositoryProvider)
        .saveNotes(widget.realizationId, widget.taskId, notes);
    if (!mounted) return;
    setState(() {
      _saved = notes;
      _saving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!_expanded) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => setState(() => _expanded = true),
          icon: const Icon(Icons.note_add_outlined),
          label: Text(l10n.addNote),
        ),
      );
    }
    final changed = _controller.text.trim() != _saved;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          controller: _controller,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.multiline,
          minLines: 2,
          maxLines: 6,
          decoration: InputDecoration(
            labelText: l10n.noteLabel,
            hintText: l10n.noteHint,
            alignLabelWithHint: true,
            border: const OutlineInputBorder(),
          ),
        ),
        if (changed)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.save_outlined),
              label: Text(l10n.saveNote),
            ),
          ),
      ],
    );
  }
}
