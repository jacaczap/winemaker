// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_realization_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller of one realization.
///
/// Its mutations never publish an `AsyncValue.loading()` in between: that
/// would drop the current value and blink the realization view back to a
/// spinner and a placeholder title on every completed step.

@ProviderFor(RecipeRealizationController)
final recipeRealizationControllerProvider =
    RecipeRealizationControllerFamily._();

/// Controller of one realization.
///
/// Its mutations never publish an `AsyncValue.loading()` in between: that
/// would drop the current value and blink the realization view back to a
/// spinner and a placeholder title on every completed step.
final class RecipeRealizationControllerProvider extends $AsyncNotifierProvider<
    RecipeRealizationController, RecipeRealization> {
  /// Controller of one realization.
  ///
  /// Its mutations never publish an `AsyncValue.loading()` in between: that
  /// would drop the current value and blink the realization view back to a
  /// spinner and a placeholder title on every completed step.
  RecipeRealizationControllerProvider._(
      {required RecipeRealizationControllerFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'recipeRealizationControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$recipeRealizationControllerHash();

  @override
  String toString() {
    return r'recipeRealizationControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RecipeRealizationController create() => RecipeRealizationController();

  @override
  bool operator ==(Object other) {
    return other is RecipeRealizationControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipeRealizationControllerHash() =>
    r'239eca0037cb3ff74bd7605be42d0a79efddbc35';

/// Controller of one realization.
///
/// Its mutations never publish an `AsyncValue.loading()` in between: that
/// would drop the current value and blink the realization view back to a
/// spinner and a placeholder title on every completed step.

final class RecipeRealizationControllerFamily extends $Family
    with
        $ClassFamilyOverride<
            RecipeRealizationController,
            AsyncValue<RecipeRealization>,
            RecipeRealization,
            FutureOr<RecipeRealization>,
            int> {
  RecipeRealizationControllerFamily._()
      : super(
          retry: null,
          name: r'recipeRealizationControllerProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Controller of one realization.
  ///
  /// Its mutations never publish an `AsyncValue.loading()` in between: that
  /// would drop the current value and blink the realization view back to a
  /// spinner and a placeholder title on every completed step.

  RecipeRealizationControllerProvider call(
    int id,
  ) =>
      RecipeRealizationControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'recipeRealizationControllerProvider';
}

/// Controller of one realization.
///
/// Its mutations never publish an `AsyncValue.loading()` in between: that
/// would drop the current value and blink the realization view back to a
/// spinner and a placeholder title on every completed step.

abstract class _$RecipeRealizationController
    extends $AsyncNotifier<RecipeRealization> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  FutureOr<RecipeRealization> build(
    int id,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<RecipeRealization>, RecipeRealization>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<RecipeRealization>, RecipeRealization>,
        AsyncValue<RecipeRealization>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}

/// Home-list controller: streams all realizations and owns create/delete.

@ProviderFor(RecipeRealizationsController)
final recipeRealizationsControllerProvider =
    RecipeRealizationsControllerProvider._();

/// Home-list controller: streams all realizations and owns create/delete.
final class RecipeRealizationsControllerProvider
    extends $StreamNotifierProvider<RecipeRealizationsController,
        List<RecipeRealization>> {
  /// Home-list controller: streams all realizations and owns create/delete.
  RecipeRealizationsControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'recipeRealizationsControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$recipeRealizationsControllerHash();

  @$internal
  @override
  RecipeRealizationsController create() => RecipeRealizationsController();
}

String _$recipeRealizationsControllerHash() =>
    r'f3b15a18eb5688cbaa301dcaa7b9c3a01cf1bd9c';

/// Home-list controller: streams all realizations and owns create/delete.

abstract class _$RecipeRealizationsController
    extends $StreamNotifier<List<RecipeRealization>> {
  Stream<List<RecipeRealization>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<RecipeRealization>>, List<RecipeRealization>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<RecipeRealization>>,
            List<RecipeRealization>>,
        AsyncValue<List<RecipeRealization>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
