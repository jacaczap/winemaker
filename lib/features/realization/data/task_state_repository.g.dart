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
