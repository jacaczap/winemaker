import 'task_type.dart';

class Task {
  final String name;
  final TaskType type;
  final Map<String, Object>? args;
  final String? description;

  const Task(this.name, this.type, {this.args, this.description});
}
