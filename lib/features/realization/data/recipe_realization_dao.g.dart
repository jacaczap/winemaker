// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_realization_dao.dart';

// ignore_for_file: type=lint
mixin _$RecipeRealizationDaoMixin on DatabaseAccessor<MyDatabase> {
  $RecipeRealizationEntityTable get recipeRealizationEntity =>
      attachedDatabase.recipeRealizationEntity;
  RecipeRealizationDaoManager get managers => RecipeRealizationDaoManager(this);
}

class RecipeRealizationDaoManager {
  final _$RecipeRealizationDaoMixin _db;
  RecipeRealizationDaoManager(this._db);
  $$RecipeRealizationEntityTableTableManager get recipeRealizationEntity =>
      $$RecipeRealizationEntityTableTableManager(
          _db.attachedDatabase, _db.recipeRealizationEntity);
}
