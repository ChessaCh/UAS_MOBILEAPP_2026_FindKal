import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Unit Test: Verifikasi OTP Email harus cocok', () {
    final result = verifyEmailOtp('8888', '8888');
    expect(result, true);
  });
}

bool verifyEmailOtp(String input, String expected) => input == expected;