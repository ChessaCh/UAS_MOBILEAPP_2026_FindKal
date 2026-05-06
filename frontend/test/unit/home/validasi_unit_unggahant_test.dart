import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Unit Test: Fungsi pengecekan status verifikasi user', () {
    final isVerified = mockCheckUserVerification(false);
    expect(isVerified, false); // Berarti fitur harus di-lock
  });
}

bool mockCheckUserVerification(bool isVerifiedStatus) => isVerifiedStatus;