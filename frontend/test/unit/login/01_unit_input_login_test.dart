import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Unit Test: Input Username/Email dan Password', () {
    test('Validasi email mengembalikan error jika kosong', () {
      final result = validateEmail('');
      expect(result, 'Email/Username tidak boleh kosong');
    });

    test('Validasi email sukses jika diisi', () {
      final result = validateEmail('irsyad@email.com');
      expect(result, null);
    });

    test('Validasi password mengembalikan error jika kosong', () {
      final result = validatePassword('');
      expect(result, 'Password tidak boleh kosong');
    });

    test('Validasi password sukses jika diisi', () {
      final result = validatePassword('rahasia123');
      expect(result, null);
    });
  });
}

// Mock fungsi validator (Sesuaikan dengan fungsi aslimu di proyek)
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'Email/Username tidak boleh kosong';
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
  return null;
}