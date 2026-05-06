import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Unit Test: Validasi Input Password Baru minimal 8 karakter', () {
    final result = validateNewPassword('pendek');
    expect(result, 'Password minimal 8 karakter');
  });
}

String? validateNewPassword(String? val) => (val == null || val.length < 8) ? 'Password minimal 8 karakter' : null;