// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_state_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(taskStateRepository)
final taskStateRepositoryProvider = TaskStateRepositoryProvider._();

final class TaskStateRepositoryProvider extends $FunctionalProvider<
    TaskStateRepository,
    TaskStateRepository,
    TaskStateRepository> with $Provider<TaskStateRepository> {
  TaskStateRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'taskStateRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$taskStateRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskStateRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskStateRepository create(Ref ref) {
    return taskStateRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskStateRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskStateRepository>(value),
    );
  }
}

String _$taskStateRepositoryHash() =>
    r'b44b80e751dd977b6356be70c0743eda204c4011';

/// Live per-task rows of one realization, keyed by task id.

@ProviderFor(taskStates)
final taskStatesProvider = TaskStatesFamily._();

/// Live per-task rows of one realization, keyed by task id.

final class TaskStatesProvider extends $FunctionalProvider<
        AsyncValue<Map<RecipeTaskId, TaskStateRecord>>,
        Map<RecipeTaskId, TaskStateRecord>,
        Stream<Map<RecipeTaskId, TaskStateRecord>>>
    with
        $FutureModifier<Map<RecipeTaskId, TaskStateRecord>>,
        $StreamProvider<Map<RecipeTaskId, TaskStateRecord>> {
  /// Live per-task rows of one realization, keyed by task id.
  TaskStatesProvider._(
      {required TaskStatesFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'taskStatesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$taskStatesHash();

  @override
  String toString() {
    return r'taskStatesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Map<RecipeTaskId, TaskStateRecord>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Map<RecipeTaskId, TaskStateRecord>> create(Ref ref) {
    final argument = this.argument as int;
    return taskStates(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TaskStatesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskStatesHash() => r'18dc9b63384cb7c4d35382c12968c592da697173';

/// Live per-task rows of one realization, keyed by task id.

final class TaskStatesFamily extends $Family
    with
        $FunctionalFamilyOverride<Stream<Map<RecipeTaskId, TaskStateRecord>>,
            int> {
  TaskStatesFamily._()
      : super(
          retry: null,
          name: r'taskStatesProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Live per-task rows of one realization, keyed by task id.

  TaskStatesProvider call(
    int realizationId,
  ) =>
      TaskStatesProvider._(argument: realizationId, from: this);

  @override
  String toString() => r'taskStatesProvider';
}
