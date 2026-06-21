import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:winemaker/core/notifications/notification_service.dart';
import 'package:winemaker/features/realization/data/task_state_repository.dart';
import 'package:winemaker/features/realization/domain/task_screen_result.dart';
import 'package:winemaker/features/realization/domain/time_notification_payload.dart';
import 'package:winemaker/features/realization/presentation/redo_from_here_button.dart';

/// Waiting-period task: schedules a reminder and counts down to it.
///
/// The reminder is scheduled the first time the task is opened and reused on
/// later visits. The user can postpone it or complete the wait early as an
/// override. Completing or reverting cancels the pending reminder.
class TimeNotificationScreen extends ConsumerStatefulWidget {
  const TimeNotificationScreen({
    super.key,
    required this.realizationId,
    required this.taskIndex,
    required this.title,
    required this.description,
    required this.delay,
    required this.postpone,
    this.readOnly = false,
  });

  final int realizationId;
  final int taskIndex;
  final String title;
  final String description;
  final Duration delay;
  final Duration postpone;
  final bool readOnly;

  @override
  ConsumerState<TimeNotificationScreen> createState() =>
      _TimeNotificationScreenState();
}

class _TimeNotificationScreenState
    extends ConsumerState<TimeNotificationScreen> {
  Timer? _ticker;
  DateTime? _scheduledFor;
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {}),
    );
    _init();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    final record = await ref
        .read(taskStateRepositoryProvider)
        .get(widget.realizationId, widget.taskIndex);
    if (!mounted) return;
    final json = record?.payloadJson;
    if (json != null) {
      setState(() {
        _scheduledFor = TimeNotificationPayload.fromJson(json).scheduledFor;
        _loading = false;
      });
      return;
    }
    if (widget.readOnly) {
      setState(() => _loading = false);
      return;
    }
    await _reschedule(DateTime.now().add(widget.delay));
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _reschedule(DateTime scheduledFor) async {
    await ref.read(notificationServiceProvider).scheduleTaskReminder(
          realizationId: widget.realizationId,
          taskIndex: widget.taskIndex,
          title: widget.title,
          body: widget.description,
          scheduledFor: scheduledFor,
          postponeDays: widget.postpone.inDays,
        );
    await ref.read(taskStateRepositoryProvider).savePending(
          widget.realizationId,
          widget.taskIndex,
          payload: TimeNotificationPayload(scheduledFor: scheduledFor),
        );
    if (mounted) setState(() => _scheduledFor = scheduledFor);
  }

  Future<void> _postpone() async {
    final base = _scheduledFor ?? DateTime.now();
    setState(() => _busy = true);
    await _reschedule(base.add(widget.postpone));
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _complete() async {
    setState(() => _busy = true);
    await ref
        .read(notificationServiceProvider)
        .cancel(widget.realizationId, widget.taskIndex);
    await ref.read(taskStateRepositoryProvider).markCompleted(
          widget.realizationId,
          widget.taskIndex,
          payload: TimeNotificationPayload(
            scheduledFor: _scheduledFor ?? DateTime.now(),
          ),
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
          : SafeArea(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    final scheduledFor = _scheduledFor;
    final remaining =
        scheduledFor?.difference(DateTime.now()) ?? Duration.zero;
    final ready = remaining <= Duration.zero;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.description.isNotEmpty) ...[
            Text(
              widget.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
          ],
          _CountdownCard(
            ready: ready,
            remaining: remaining,
            scheduledFor: scheduledFor,
          ),
          const SizedBox(height: 24),
          if (widget.readOnly)
            RedoFromHereButton(
              onPressed: () => context.pop(TaskScreenResult.redo),
            )
          else ...[
            if (widget.postpone > Duration.zero)
              OutlinedButton.icon(
                onPressed: _busy ? null : _postpone,
                icon: const Icon(Icons.snooze_outlined),
                label: Text('Postpone ${widget.postpone.inDays} days'),
              ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _busy ? null : _complete,
              icon: const Icon(Icons.check),
              label: Text(ready ? 'Mark as done' : 'Complete now'),
            ),
          ],
        ],
      ),
    );
  }
}

class _CountdownCard extends StatelessWidget {
  const _CountdownCard({
    required this.ready,
    required this.remaining,
    required this.scheduledFor,
  });

  final bool ready;
  final Duration remaining;
  final DateTime? scheduledFor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              ready ? Icons.notifications_active_outlined : Icons.timer_outlined,
              size: 40,
              color: colors.primary,
            ),
            const SizedBox(height: 12),
            Text(
              ready ? 'Ready to continue' : _formatRemaining(remaining),
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              ready
                  ? 'The waiting period is over.'
                  : scheduledFor == null
                      ? ''
                      : 'Reminder on ${_formatDate(scheduledFor!)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      DateFormat('EEE, d MMM yyyy, HH:mm').format(date);

  String _formatRemaining(Duration remaining) {
    final days = remaining.inDays;
    final hours = remaining.inHours % 24;
    final minutes = remaining.inMinutes % 60;
    if (days > 0) return '$days d $hours h left';
    if (hours > 0) return '$hours h $minutes m left';
    final seconds = remaining.inSeconds % 60;
    return '$minutes m $seconds s left';
  }
}
