import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/recipe/domain/task.dart';
import 'package:winemaker/l10n/app_localizations.dart';

/// Free-text note attached to one task occurrence.
///
/// Collapsed until tapped, and auto-expanded when a note already exists. The
/// note is written whenever the field loses focus and again when the screen
/// goes away, so it survives whichever button the user reaches for. Writing it
/// on its own leaves the task's status, payload and completion time alone, so
/// a note can be added to an already completed task without redoing it.
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
  final _focusNode = FocusNode();

  late final TaskStateRepository _repository;
  String _saved = '';
  bool _expanded = false;
  bool _autofocus = false;

  @override
  void initState() {
    super.initState();
    _repository = ref.read(taskStateRepositoryProvider);
    _focusNode.addListener(_onFocusChanged);
    _load();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _flush();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final record =
        await _repository.get(widget.realizationId, widget.taskId);
    if (!mounted) return;
    final notes = record?.notes ?? '';
    setState(() {
      _saved = notes;
      _controller.text = notes;
      _expanded = notes.isNotEmpty;
    });
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) _flush();
  }

  /// Writes the note if it changed since the last write.
  ///
  /// Deliberately not awaited: [dispose] cannot wait, and the write has to
  /// outlive the screen the user just left.
  void _flush() {
    final notes = _controller.text.trim();
    if (notes == _saved) return;
    _saved = notes;
    _repository.saveNotes(widget.realizationId, widget.taskId, notes);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!_expanded) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => setState(() {
            _expanded = true;
            _autofocus = true;
          }),
          icon: const Icon(Icons.note_add_outlined),
          label: Text(l10n.addNote),
        ),
      );
    }
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: _autofocus,
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
    );
  }
}
