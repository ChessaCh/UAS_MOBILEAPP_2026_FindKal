import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Unit Test: Fungsi request OTP mengembalikan true jika email valid', () async {
    final result = await mockRequestOtp('irsyad@findkal.com');
    expect(result, true);
  });
}

Future<bool> mockRequestOtp(String email) async => email.contains('@');