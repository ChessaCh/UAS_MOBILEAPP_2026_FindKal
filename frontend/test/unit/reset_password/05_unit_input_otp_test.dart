import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Unit Test: Validasi Input OTP harus tepat 4 digit', () {
    final result = validateOtp('123');
    expect(result, 'OTP harus 4 digit');
  });
}

String? validateOtp(String? val) => (val == null || val.length != 4) ? 'OTP harus 4 digit' : null;