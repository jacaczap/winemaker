import 'package:drift/drift.dart';
import 'package:winemaker/features/realization/domain/task_state.dart';

class TaskStateEntity extends Table {
  IntColumn get realizationId => integer()();

  IntColumn get taskIndex => integer()();

  TextColumn get status => textEnum<TaskState>()();

  TextColumn get payload => text().nullable()();

  @override
  Set<Column> get primaryKey => {realizationId, taskIndex};
}
