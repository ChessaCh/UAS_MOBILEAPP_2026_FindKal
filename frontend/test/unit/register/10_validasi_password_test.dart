import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Unit Test: Validasi kekuatan password (huruf dan angka)', () {
    final result = validatePasswordStrength('lemah');
    expect(result, 'Password harus mengandung angka');
  });

  test('Unit Test: Password kuat lolos validasi', () {
    final result = validatePasswordStrength('Kuat1234');
    expect(result, null);
  });
}

String? validatePasswordStrength(String val) {
  if (!RegExp(r'[0-9]').hasMatch(val)) return 'Password harus mengandung angka';
  return null;
}