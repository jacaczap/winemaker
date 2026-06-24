// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $RecipeRealizationEntityTable extends RecipeRealizationEntity
    with TableInfo<$RecipeRealizationEntityTable, RecipeRealizationEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeRealizationEntityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _currentTaskMeta =
      const VerificationMeta('currentTask');
  @override
  late final GeneratedColumn<int> currentTask = GeneratedColumn<int>(
      'current_task', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<AvailableRecipes, int> recipe =
      GeneratedColumn<int>('recipe', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<AvailableRecipes>(
              $RecipeRealizationEntityTable.$converterrecipe);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, currentTask, recipe, name, startTime, completed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_realization_entity';
  @override
  VerificationContext validateIntegrity(
      Insertable<RecipeRealizationEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('current_task')) {
      context.handle(
          _currentTaskMeta,
          currentTask.isAcceptableOrUnknown(
              data['current_task']!, _currentTaskMeta));
    } else if (isInserting) {
      context.missing(_currentTaskMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeRealizationEntityData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeRealizationEntityData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      currentTask: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_task'])!,
      recipe: $RecipeRealizationEntityTable.$converterrecipe.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}recipe'])!),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
    );
  }

  @override
  $RecipeRealizationEntityTable createAlias(String alias) {
    return $RecipeRealizationEntityTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AvailableRecipes, int, int> $converterrecipe =
      const EnumIndexConverter<AvailableRecipes>(AvailableRecipes.values);
}

class RecipeRealizationEntityData extends DataClass
    implements Insertable<RecipeRealizationEntityData> {
  final int id;
  final int currentTask;
  final AvailableRecipes recipe;
  final String? name;
  final DateTime startTime;
  final bool completed;
  const RecipeRealizationEntityData(
      {required this.id,
      required this.currentTask,
      required this.recipe,
      this.name,
      required this.startTime,
      required this.completed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['current_task'] = Variable<int>(currentTask);
    {
      map['recipe'] = Variable<int>(
          $RecipeRealizationEntityTable.$converterrecipe.toSql(recipe));
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['start_time'] = Variable<DateTime>(startTime);
    map['completed'] = Variable<bool>(completed);
    return map;
  }

  RecipeRealizationEntityCompanion toCompanion(bool nullToAbsent) {
    return RecipeRealizationEntityCompanion(
      id: Value(id),
      currentTask: Value(currentTask),
      recipe: Value(recipe),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      startTime: Value(startTime),
      completed: Value(completed),
    );
  }

  factory RecipeRealizationEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeRealizationEntityData(
      id: serializer.fromJson<int>(json['id']),
      currentTask: serializer.fromJson<int>(json['currentTask']),
      recipe: $RecipeRealizationEntityTable.$converterrecipe
          .fromJson(serializer.fromJson<int>(json['recipe'])),
      name: serializer.fromJson<String?>(json['name']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      completed: serializer.fromJson<bool>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currentTask': serializer.toJson<int>(currentTask),
      'recipe': serializer.toJson<int>(
          $RecipeRealizationEntityTable.$converterrecipe.toJson(recipe)),
      'name': serializer.toJson<String?>(name),
      'startTime': serializer.toJson<DateTime>(startTime),
      'completed': serializer.toJson<bool>(completed),
    };
  }

  RecipeRealizationEntityData copyWith(
          {int? id,
          int? currentTask,
          AvailableRecipes? recipe,
          Value<String?> name = const Value.absent(),
          DateTime? startTime,
          bool? completed}) =>
      RecipeRealizationEntityData(
        id: id ?? this.id,
        currentTask: currentTask ?? this.currentTask,
        recipe: recipe ?? this.recipe,
        name: name.present ? name.value : this.name,
        startTime: startTime ?? this.startTime,
        completed: completed ?? this.completed,
      );
  RecipeRealizationEntityData copyWithCompanion(
      RecipeRealizationEntityCompanion data) {
    return RecipeRealizationEntityData(
      id: data.id.present ? data.id.value : this.id,
      currentTask:
          data.currentTask.present ? data.currentTask.value : this.currentTask,
      recipe: data.recipe.present ? data.recipe.value : this.recipe,
      name: data.name.present ? data.name.value : this.name,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      completed: data.completed.present ? data.completed.value : this.completed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeRealizationEntityData(')
          ..write('id: $id, ')
          ..write('currentTask: $currentTask, ')
          ..write('recipe: $recipe, ')
          ..write('name: $name, ')
          ..write('startTime: $startTime, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, currentTask, recipe, name, startTime, completed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeRealizationEntityData &&
          other.id == this.id &&
          other.currentTask == this.currentTask &&
          other.recipe == this.recipe &&
          other.name == this.name &&
          other.startTime == this.startTime &&
          other.completed == this.completed);
}

class RecipeRealizationEntityCompanion
    extends UpdateCompanion<RecipeRealizationEntityData> {
  final Value<int> id;
  final Value<int> currentTask;
  final Value<AvailableRecipes> recipe;
  final Value<String?> name;
  final Value<DateTime> startTime;
  final Value<bool> completed;
  const RecipeRealizationEntityCompanion({
    this.id = const Value.absent(),
    this.currentTask = const Value.absent(),
    this.recipe = const Value.absent(),
    this.name = const Value.absent(),
    this.startTime = const Value.absent(),
    this.completed = const Value.absent(),
  });
  RecipeRealizationEntityCompanion.insert({
    this.id = const Value.absent(),
    required int currentTask,
    required AvailableRecipes recipe,
    this.name = const Value.absent(),
    this.startTime = const Value.absent(),
    this.completed = const Value.absent(),
  })  : currentTask = Value(currentTask),
        recipe = Value(recipe);
  static Insertable<RecipeRealizationEntityData> custom({
    Expression<int>? id,
    Expression<int>? currentTask,
    Expression<int>? recipe,
    Expression<String>? name,
    Expression<DateTime>? startTime,
    Expression<bool>? completed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentTask != null) 'current_task': currentTask,
      if (recipe != null) 'recipe': recipe,
      if (name != null) 'name': name,
      if (startTime != null) 'start_time': startTime,
      if (completed != null) 'completed': completed,
    });
  }

  RecipeRealizationEntityCompanion copyWith(
      {Value<int>? id,
      Value<int>? currentTask,
      Value<AvailableRecipes>? recipe,
      Value<String?>? name,
      Value<DateTime>? startTime,
      Value<bool>? completed}) {
    return RecipeRealizationEntityCompanion(
      id: id ?? this.id,
      currentTask: currentTask ?? this.currentTask,
      recipe: recipe ?? this.recipe,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      completed: completed ?? this.completed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currentTask.present) {
      map['current_task'] = Variable<int>(currentTask.value);
    }
    if (recipe.present) {
      map['recipe'] = Variable<int>(
          $RecipeRealizationEntityTable.$converterrecipe.toSql(recipe.value));
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeRealizationEntityCompanion(')
          ..write('id: $id, ')
          ..write('currentTask: $currentTask, ')
          ..write('recipe: $recipe, ')
          ..write('name: $name, ')
          ..write('startTime: $startTime, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }
}

class $TaskStateEntityTable extends TaskStateEntity
    with TableInfo<$TaskStateEntityTable, TaskStateEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskStateEntityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _realizationIdMeta =
      const VerificationMeta('realizationId');
  @override
  late final GeneratedColumn<int> realizationId = GeneratedColumn<int>(
      'realization_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _taskIndexMeta =
      const VerificationMeta('taskIndex');
  @override
  late final GeneratedColumn<int> taskIndex = GeneratedColumn<int>(
      'task_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<TaskState, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TaskState>($TaskStateEntityTable.$converterstatus);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [realizationId, taskIndex, status, payload];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_state_entity';
  @override
  VerificationContext validateIntegrity(
      Insertable<TaskStateEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('realization_id')) {
      context.handle(
          _realizationIdMeta,
          realizationId.isAcceptableOrUnknown(
              data['realization_id']!, _realizationIdMeta));
    } else if (isInserting) {
      context.missing(_realizationIdMeta);
    }
    if (data.containsKey('task_index')) {
      context.handle(_taskIndexMeta,
          taskIndex.isAcceptableOrUnknown(data['task_index']!, _taskIndexMeta));
    } else if (isInserting) {
      context.missing(_taskIndexMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {realizationId, taskIndex};
  @override
  TaskStateEntityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskStateEntityData(
      realizationId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}realization_id'])!,
      taskIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}task_index'])!,
      status: $TaskStateEntityTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload']),
    );
  }

  @override
  $TaskStateEntityTable createAlias(String alias) {
    return $TaskStateEntityTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskState, String, String> $converterstatus =
      const EnumNameConverter<TaskState>(TaskState.values);
}

class TaskStateEntityData extends DataClass
    implements Insertable<TaskStateEntityData> {
  final int realizationId;
  final int taskIndex;
  final TaskState status;
  final String? payload;
  const TaskStateEntityData(
      {required this.realizationId,
      required this.taskIndex,
      required this.status,
      this.payload});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['realization_id'] = Variable<int>(realizationId);
    map['task_index'] = Variable<int>(taskIndex);
    {
      map['status'] = Variable<String>(
          $TaskStateEntityTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    return map;
  }

  TaskStateEntityCompanion toCompanion(bool nullToAbsent) {
    return TaskStateEntityCompanion(
      realizationId: Value(realizationId),
      taskIndex: Value(taskIndex),
      status: Value(status),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
    );
  }

  factory TaskStateEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskStateEntityData(
      realizationId: serializer.fromJson<int>(json['realizationId']),
      taskIndex: serializer.fromJson<int>(json['taskIndex']),
      status: $TaskStateEntityTable.$converterstatus
          .fromJson(serializer.fromJson<String>(json['status'])),
      payload: serializer.fromJson<String?>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'realizationId': serializer.toJson<int>(realizationId),
      'taskIndex': serializer.toJson<int>(taskIndex),
      'status': serializer.toJson<String>(
          $TaskStateEntityTable.$converterstatus.toJson(status)),
      'payload': serializer.toJson<String?>(payload),
    };
  }

  TaskStateEntityData copyWith(
          {int? realizationId,
          int? taskIndex,
          TaskState? status,
          Value<String?> payload = const Value.absent()}) =>
      TaskStateEntityData(
        realizationId: realizationId ?? this.realizationId,
        taskIndex: taskIndex ?? this.taskIndex,
        status: status ?? this.status,
        payload: payload.present ? payload.value : this.payload,
      );
  TaskStateEntityData copyWithCompanion(TaskStateEntityCompanion data) {
    return TaskStateEntityData(
      realizationId: data.realizationId.present
          ? data.realizationId.value
          : this.realizationId,
      taskIndex: data.taskIndex.present ? data.taskIndex.value : this.taskIndex,
      status: data.status.present ? data.status.value : this.status,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskStateEntityData(')
          ..write('realizationId: $realizationId, ')
          ..write('taskIndex: $taskIndex, ')
          ..write('status: $status, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(realizationId, taskIndex, status, payload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskStateEntityData &&
          other.realizationId == this.realizationId &&
          other.taskIndex == this.taskIndex &&
          other.status == this.status &&
          other.payload == this.payload);
}

class TaskStateEntityCompanion extends UpdateCompanion<TaskStateEntityData> {
  final Value<int> realizationId;
  final Value<int> taskIndex;
  final Value<TaskState> status;
  final Value<String?> payload;
  final Value<int> rowid;
  const TaskStateEntityCompanion({
    this.realizationId = const Value.absent(),
    this.taskIndex = const Value.absent(),
    this.status = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskStateEntityCompanion.insert({
    required int realizationId,
    required int taskIndex,
    required TaskState status,
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : realizationId = Value(realizationId),
        taskIndex = Value(taskIndex),
        status = Value(status);
  static Insertable<TaskStateEntityData> custom({
    Expression<int>? realizationId,
    Expression<int>? taskIndex,
    Expression<String>? status,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (realizationId != null) 'realization_id': realizationId,
      if (taskIndex != null) 'task_index': taskIndex,
      if (status != null) 'status': status,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskStateEntityCompanion copyWith(
      {Value<int>? realizationId,
      Value<int>? taskIndex,
      Value<TaskState>? status,
      Value<String?>? payload,
      Value<int>? rowid}) {
    return TaskStateEntityCompanion(
      realizationId: realizationId ?? this.realizationId,
      taskIndex: taskIndex ?? this.taskIndex,
      status: status ?? this.status,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (realizationId.present) {
      map['realization_id'] = Variable<int>(realizationId.value);
    }
    if (taskIndex.present) {
      map['task_index'] = Variable<int>(taskIndex.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $TaskStateEntityTable.$converterstatus.toSql(status.value));
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskStateEntityCompanion(')
          ..write('realizationId: $realizationId, ')
          ..write('taskIndex: $taskIndex, ')
          ..write('status: $status, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  $MyDatabaseManager get managers => $MyDatabaseManager(this);
  late final $RecipeRealizationEntityTable recipeRealizationEntity =
      $RecipeRealizationEntityTable(this);
  late final $TaskStateEntityTable taskStateEntity =
      $TaskStateEntityTable(this);
  late final RecipeRealizationDao recipeRealizationDao =
      RecipeRealizationDao(this as MyDatabase);
  late final TaskStateDao taskStateDao = TaskStateDao(this as MyDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [recipeRealizationEntity, taskStateEntity];
}

typedef $$RecipeRealizationEntityTableCreateCompanionBuilder
    = RecipeRealizationEntityCompanion Function({
  Value<int> id,
  required int currentTask,
  required AvailableRecipes recipe,
  Value<String?> name,
  Value<DateTime> startTime,
  Value<bool> completed,
});
typedef $$RecipeRealizationEntityTableUpdateCompanionBuilder
    = RecipeRealizationEntityCompanion Function({
  Value<int> id,
  Value<int> currentTask,
  Value<AvailableRecipes> recipe,
  Value<String?> name,
  Value<DateTime> startTime,
  Value<bool> completed,
});

class $$RecipeRealizationEntityTableFilterComposer
    extends Composer<_$MyDatabase, $RecipeRealizationEntityTable> {
  $$RecipeRealizationEntityTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentTask => $composableBuilder(
      column: $table.currentTask, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AvailableRecipes, AvailableRecipes, int>
      get recipe => $composableBuilder(
          column: $table.recipe,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));
}

class $$RecipeRealizationEntityTableOrderingComposer
    extends Composer<_$MyDatabase, $RecipeRealizationEntityTable> {
  $$RecipeRealizationEntityTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentTask => $composableBuilder(
      column: $table.currentTask, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recipe => $composableBuilder(
      column: $table.recipe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));
}

class $$RecipeRealizationEntityTableAnnotationComposer
    extends Composer<_$MyDatabase, $RecipeRealizationEntityTable> {
  $$RecipeRealizationEntityTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentTask => $composableBuilder(
      column: $table.currentTask, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AvailableRecipes, int> get recipe =>
      $composableBuilder(column: $table.recipe, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);
}

class $$RecipeRealizationEntityTableTableManager extends RootTableManager<
    _$MyDatabase,
    $RecipeRealizationEntityTable,
    RecipeRealizationEntityData,
    $$RecipeRealizationEntityTableFilterComposer,
    $$RecipeRealizationEntityTableOrderingComposer,
    $$RecipeRealizationEntityTableAnnotationComposer,
    $$RecipeRealizationEntityTableCreateCompanionBuilder,
    $$RecipeRealizationEntityTableUpdateCompanionBuilder,
    (
      RecipeRealizationEntityData,
      BaseReferences<_$MyDatabase, $RecipeRealizationEntityTable,
          RecipeRealizationEntityData>
    ),
    RecipeRealizationEntityData,
    PrefetchHooks Function()> {
  $$RecipeRealizationEntityTableTableManager(
      _$MyDatabase db, $RecipeRealizationEntityTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeRealizationEntityTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeRealizationEntityTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeRealizationEntityTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> currentTask = const Value.absent(),
            Value<AvailableRecipes> recipe = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<bool> completed = const Value.absent(),
          }) =>
              RecipeRealizationEntityCompanion(
            id: id,
            currentTask: currentTask,
            recipe: recipe,
            name: name,
            startTime: startTime,
            completed: completed,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int currentTask,
            required AvailableRecipes recipe,
            Value<String?> name = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<bool> completed = const Value.absent(),
          }) =>
              RecipeRealizationEntityCompanion.insert(
            id: id,
            currentTask: currentTask,
            recipe: recipe,
            name: name,
            startTime: startTime,
            completed: completed,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecipeRealizationEntityTableProcessedTableManager
    = ProcessedTableManager<
        _$MyDatabase,
        $RecipeRealizationEntityTable,
        RecipeRealizationEntityData,
        $$RecipeRealizationEntityTableFilterComposer,
        $$RecipeRealizationEntityTableOrderingComposer,
        $$RecipeRealizationEntityTableAnnotationComposer,
        $$RecipeRealizationEntityTableCreateCompanionBuilder,
        $$RecipeRealizationEntityTableUpdateCompanionBuilder,
        (
          RecipeRealizationEntityData,
          BaseReferences<_$MyDatabase, $RecipeRealizationEntityTable,
              RecipeRealizationEntityData>
        ),
        RecipeRealizationEntityData,
        PrefetchHooks Function()>;
typedef $$TaskStateEntityTableCreateCompanionBuilder = TaskStateEntityCompanion
    Function({
  required int realizationId,
  required int taskIndex,
  required TaskState status,
  Value<String?> payload,
  Value<int> rowid,
});
typedef $$TaskStateEntityTableUpdateCompanionBuilder = TaskStateEntityCompanion
    Function({
  Value<int> realizationId,
  Value<int> taskIndex,
  Value<TaskState> status,
  Value<String?> payload,
  Value<int> rowid,
});

class $$TaskStateEntityTableFilterComposer
    extends Composer<_$MyDatabase, $TaskStateEntityTable> {
  $$TaskStateEntityTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get realizationId => $composableBuilder(
      column: $table.realizationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get taskIndex => $composableBuilder(
      column: $table.taskIndex, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TaskState, TaskState, String> get status =>
      $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));
}

class $$TaskStateEntityTableOrderingComposer
    extends Composer<_$MyDatabase, $TaskStateEntityTable> {
  $$TaskStateEntityTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get realizationId => $composableBuilder(
      column: $table.realizationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get taskIndex => $composableBuilder(
      column: $table.taskIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));
}

class $$TaskStateEntityTableAnnotationComposer
    extends Composer<_$MyDatabase, $TaskStateEntityTable> {
  $$TaskStateEntityTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get realizationId => $composableBuilder(
      column: $table.realizationId, builder: (column) => column);

  GeneratedColumn<int> get taskIndex =>
      $composableBuilder(column: $table.taskIndex, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskState, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);
}

class $$TaskStateEntityTableTableManager extends RootTableManager<
    _$MyDatabase,
    $TaskStateEntityTable,
    TaskStateEntityData,
    $$TaskStateEntityTableFilterComposer,
    $$TaskStateEntityTableOrderingComposer,
    $$TaskStateEntityTableAnnotationComposer,
    $$TaskStateEntityTableCreateCompanionBuilder,
    $$TaskStateEntityTableUpdateCompanionBuilder,
    (
      TaskStateEntityData,
      BaseReferences<_$MyDatabase, $TaskStateEntityTable, TaskStateEntityData>
    ),
    TaskStateEntityData,
    PrefetchHooks Function()> {
  $$TaskStateEntityTableTableManager(
      _$MyDatabase db, $TaskStateEntityTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskStateEntityTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskStateEntityTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskStateEntityTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> realizationId = const Value.absent(),
            Value<int> taskIndex = const Value.absent(),
            Value<TaskState> status = const Value.absent(),
            Value<String?> payload = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskStateEntityCompanion(
            realizationId: realizationId,
            taskIndex: taskIndex,
            status: status,
            payload: payload,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int realizationId,
            required int taskIndex,
            required TaskState status,
            Value<String?> payload = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskStateEntityCompanion.insert(
            realizationId: realizationId,
            taskIndex: taskIndex,
            status: status,
            payload: payload,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TaskStateEntityTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $TaskStateEntityTable,
    TaskStateEntityData,
    $$TaskStateEntityTableFilterComposer,
    $$TaskStateEntityTableOrderingComposer,
    $$TaskStateEntityTableAnnotationComposer,
    $$TaskStateEntityTableCreateCompanionBuilder,
    $$TaskStateEntityTableUpdateCompanionBuilder,
    (
      TaskStateEntityData,
      BaseReferences<_$MyDatabase, $TaskStateEntityTable, TaskStateEntityData>
    ),
    TaskStateEntityData,
    PrefetchHooks Function()>;

class $MyDatabaseManager {
  final _$MyDatabase _db;
  $MyDatabaseManager(this._db);
  $$RecipeRealizationEntityTableTableManager get recipeRealizationEntity =>
      $$RecipeRealizationEntityTableTableManager(
          _db, _db.recipeRealizationEntity);
  $$TaskStateEntityTableTableManager get taskStateEntity =>
      $$TaskStateEntityTableTableManager(_db, _db.taskStateEntity);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(database)
final databaseProvider = DatabaseProvider._();

final class DatabaseProvider
    extends $FunctionalProvider<MyDatabase, MyDatabase, MyDatabase>
    with $Provider<MyDatabase> {
  DatabaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'databaseProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$databaseHash();

  @$internal
  @override
  $ProviderElement<MyDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MyDatabase create(Ref ref) {
    return database(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyDatabase>(value),
    );
  }
}

String _$databaseHash() => r'deb38e95b72d66c518735967bc3d248016aa8627';
