// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_state_dao.dart';

// ignore_for_file: type=lint
mixin _$TaskStateDaoMixin on DatabaseAccessor<MyDatabase> {
  $TaskStateEntityTable get taskStateEntity => attachedDatabase.taskStateEntity;
  TaskStateDaoManager get managers => TaskStateDaoManager(this);
}

class TaskStateDaoManager {
  final _$TaskStateDaoMixin _db;
  TaskStateDaoManager(this._db);
  $$TaskStateEntityTableTableManager get taskStateEntity =>
      $$TaskStateEntityTableTableManager(
          _db.attachedDatabase, _db.taskStateEntity);
}
