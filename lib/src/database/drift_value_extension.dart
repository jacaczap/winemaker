import 'package:drift/drift.dart';

extension ToDriftValue<T> on T {
  Value<T> toDriftValue() => Value(this);
}
