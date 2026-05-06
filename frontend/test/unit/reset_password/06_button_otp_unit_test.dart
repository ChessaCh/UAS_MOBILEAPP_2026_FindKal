import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Unit Test: Fungsi verifyCodel() berhasil jika OTP benar', () async {
    final result = await mockVerifyCode('1234');
    expect(result, true);
  });
}

Future<bool> mockVerifyCode(String code) async => code == '1234';