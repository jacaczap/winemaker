import 'package:drift/drift.dart';

class MustEntity extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get volume => real()();

  RealColumn get sugar => real()();
}
