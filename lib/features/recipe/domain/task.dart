import 'task_type.dart';

class Task {
  final String name;
  final TaskType type;
  final String? description;
  final TimeNotificationParams? notification;

  const Task(this.name, this.type, {this.description, this.notification});
}

/// Timing parameters for a [TaskType.timeNotification] task.
///
/// [delay] is how long to wait before the reminder fires; [postpone] is how
/// far each "postpone" pushes it back.
class TimeNotificationParams {
  final Duration delay;
  final Duration postpone;

  const TimeNotificationParams({required this.delay, required this.postpone});
}
