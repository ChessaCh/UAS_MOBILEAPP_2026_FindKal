import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Unit Test: Validasi Input Form (Nama/Email) tidak boleh kosong', () {
    final result = validateRequiredField('');
    expect(result, 'Kolom ini wajib diisi');
  });
}

String? validateRequiredField(String? val) => (val == null || val.isEmpty) ? 'Kolom ini wajib diisi' : null;