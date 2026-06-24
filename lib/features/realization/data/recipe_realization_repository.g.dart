// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_realization_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recipeRealizationRepository)
final recipeRealizationRepositoryProvider =
    RecipeRealizationRepositoryProvider._();

final class RecipeRealizationRepositoryProvider extends $FunctionalProvider<
    RecipeRealizationRepository,
    RecipeRealizationRepository,
    RecipeRealizationRepository> with $Provider<RecipeRealizationRepository> {
  RecipeRealizationRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'recipeRealizationRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$recipeRealizationRepositoryHash();

  @$internal
  @override
  $ProviderElement<RecipeRealizationRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecipeRealizationRepository create(Ref ref) {
    return recipeRealizationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecipeRealizationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecipeRealizationRepository>(value),
    );
  }
}

String _$recipeRealizationRepositoryHash() =>
    r'e0bae70d344a0480f381eed14ddd50586413c5ae';
