import 'package:winemaker/features/realization/domain/task_state.dart';

/// Per-occurrence data for a `timeNotification` task.
///
/// Stores when the reminder is due so revisiting the task shows the remaining
/// wait and reschedules postpones from the right baseline.
class TimeNotificationPayload extends TaskPayload {
  const TimeNotificationPayload({required this.scheduledFor});

  factory TimeNotificationPayload.fromJson(Map<String, dynamic> json) =>
      TimeNotificationPayload(
        scheduledFor: DateTime.fromMillisecondsSinceEpoch(
          (json['scheduledForMillis'] as num).toInt(),
        ),
      );

  final DateTime scheduledFor;

  @override
  Map<String, dynamic> toJson() => {
        'scheduledForMillis': scheduledFor.millisecondsSinceEpoch,
      };
}
