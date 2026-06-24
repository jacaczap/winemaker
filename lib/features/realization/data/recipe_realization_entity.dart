import 'package:drift/drift.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';

class RecipeRealizationEntity extends Table {
  IntColumn get id => integer()();

  IntColumn get currentTask => integer()();

  IntColumn get recipe => intEnum<AvailableRecipes>()();

  TextColumn get name => text().nullable()();

  DateTimeColumn get startTime => dateTime().withDefault(currentDateAndTime)();

  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// class AvailableRecipesStringConverter extends TypeConverter<AvailableRecipes, String> {
//   const AvailableRecipesStringConverter();
//
//   @override
//   AvailableRecipes? mapToDart(String? fromDb) {
//     return AvailableRecipes.values.firstWhereOrNull((availableRecipe) => availableRecipe.toString().split(".").last == fromDb);
//   }
//
//   @override
//   String? mapToSql(AvailableRecipes? value) {
//     if (value == null) {
//       return null;
//     }
//
//     return value.toString();
//   }
// }
