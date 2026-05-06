import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Unit Test: Fungsi simpan password mengembalikan true', () async {
    final result = await mockSaveNewPassword('passwordBaru123');
    expect(result, true);
  });
}

Future<bool> mockSaveNewPassword(String pass) async => pass.length >= 8;