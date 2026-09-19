import 'package:drift/drift.dart';
import 'package:winemaker/features/realization/domain/task_state.dart';
import 'package:winemaker/features/recipe/domain/task.dart';

class TaskStateEntity extends Table {
  IntColumn get realizationId => integer()();

  TextColumn get taskId => textEnum<RecipeTaskId>()();

  TextColumn get status => textEnum<TaskState>()();

  TextColumn get payload => text().nullable()();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {realizationId, taskId};
}
