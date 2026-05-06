import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Unit Test: Fungsi handleLogin()', () {
    test('Mengembalikan nilai true jika kredensial benar', () async {
      final result = await mockHandleLogin('irsyad', '12345');
      expect(result, true);
    });

    test('Mengembalikan nilai false jika kredensial salah', () async {
      final result = await mockHandleLogin('salah', 'salah');
      expect(result, false);
    });
  });
}

// Mock fungsi autentikasi
Future<bool> mockHandleLogin(String username, String password) async {
  // Simulasi delay API
  await Future.delayed(const Duration(milliseconds: 100));
  if (username == 'irsyad' && password == '12345') {
    return true;
  }
  return false;
}