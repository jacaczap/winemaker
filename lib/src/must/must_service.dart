import 'package:flutter/widgets.dart';
import 'package:winemaker/src/common_models/litres.dart';
import 'package:winemaker/src/common_models/sugar.dart';
import 'package:winemaker/src/database/database.dart';
import 'package:winemaker/src/database/drift_value_extension.dart';
import 'package:winemaker/src/future/future_mapper.dart';

import 'must_measurements.dart';

void saveInitialMustMeasurements(MustMeasurements mustMeasurements, BuildContext context) {
  var database = getDatabase(context);
  database.mustDao.addMust(mustMeasurements.toEntityData());
}

void saveMustMeasurements(MustMeasurements mustMeasurements, BuildContext context) {
  var database = getDatabase(context);
  database.mustDao.updateMust(1, mustMeasurements.toEntityCompanion());
}

Future<MustMeasurements> getMustMeasurementsById(int id, BuildContext context) {
  var database = getDatabase(context);
  return database.mustDao.mustById(id).map((data) => data.toDomain());
}

extension _MustMeasurementsExtension on MustMeasurements {
  MustEntityData toEntityData() => MustEntityData(
        id: 1,
        volume: volume.value,
        sugar: sugar.value,
      );

  MustEntityCompanion toEntityCompanion() => MustEntityCompanion(
        volume: volume.value.toDriftValue(),
        sugar: sugar.value.toDriftValue(),
      );
}

extension _MustEntityDataExtension on MustEntityData {
  MustMeasurements toDomain() => MustMeasurements(Litres(volume), Blg(sugar));
}
