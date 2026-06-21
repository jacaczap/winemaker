// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_realization_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecipeRealizationController)
final recipeRealizationControllerProvider =
    RecipeRealizationControllerFamily._();

final class RecipeRealizationControllerProvider extends $AsyncNotifierProvider<
    RecipeRealizationController, RecipeRealization> {
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
    r'dc5e03d4a83a03ce2218a251778efa9a06f0c3b9';

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

  RecipeRealizationControllerProvider call(
    int id,
  ) =>
      RecipeRealizationControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'recipeRealizationControllerProvider';
}

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
