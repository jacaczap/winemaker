import 'package:flutter/widgets.dart';
import 'package:winemaker/src/common_models/alcohol.dart';
import 'package:winemaker/src/common_models/sugar.dart';
import 'package:winemaker/src/database/database.dart';
import 'package:winemaker/src/future/future_mapper.dart';

import 'desired_wine.dart';

void saveDesiredWineParameters(DesiredWine desiredWine, BuildContext context) {
  var database = getDatabase(context);
  var desiredWineEntityData = desiredWine.toEntityData();
  database.desiredWineDao.addDesiredWine(desiredWineEntityData);
}

Future<DesiredWine> getDesiredWineById(int id, BuildContext context) {
  var database = getDatabase(context);
  return database.desiredWineDao.desiredWineById(id).map((data) => data.toDomain());
}

extension _DesiredWineExtension on DesiredWine {
  DesiredWineEntityData toEntityData() => DesiredWineEntityData(
        id: 1,
        alcohol: alcohol.value,
        sugar: sugar.value,
      );
}

extension _DesiredWineEntityDataExtension on DesiredWineEntityData {
  DesiredWine toDomain() => DesiredWine(Alcohol(alcohol), GramsPerLiter(sugar));
}
