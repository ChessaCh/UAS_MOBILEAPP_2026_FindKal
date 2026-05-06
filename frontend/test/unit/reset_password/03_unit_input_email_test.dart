import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Unit Test: Validasi Input Email Reset tidak boleh kosong', () {
    final result = validateResetEmail('');
    expect(result, 'Email tidak boleh kosong');
  });

  test('Unit Test: Validasi Input Email Reset sukses', () {
    final result = validateResetEmail('irsyad@findkal.com');
    expect(result, null);
  });
}

String? validateResetEmail(String? val) => (val == null || val.isEmpty) ? 'Email tidak boleh kosong' : null;