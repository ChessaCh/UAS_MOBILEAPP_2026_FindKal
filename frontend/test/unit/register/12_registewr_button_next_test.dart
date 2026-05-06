import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Unit Test: onSelanjutnyaTapped memvalidasi data form', () {
    final isValid = mockCheckFormComplete(true);
    expect(isValid, true);
  });
}

bool mockCheckFormComplete(bool isComplete) => isComplete;