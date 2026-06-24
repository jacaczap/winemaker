import 'package:flutter_test/flutter_test.dart';
import 'package:winemaker/core/utils/math_utils.dart';

void main() {
  test('Should round double up', () {
    var result = 2.9999.roundTo(2);
    expect(result, equals(3.0));
  });

  test('Should round double down', () {
    var result = 2.1111.roundTo(1);
    expect(result, equals(2.1));
  });
}
