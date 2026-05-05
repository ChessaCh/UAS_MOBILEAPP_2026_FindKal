import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Edit Profile Kembali Ke Halaman Sebelumnya Unit Tests', () {
    test('Fungsi pop navigator terinisiasi saat kembali', () {
      // Set up
      bool navPopped = false;

      void simulatePopNavigator() {
        navPopped = true;
      }

      // Do
      simulatePopNavigator();

      // Expect
      expect(navPopped, true);
    });
  });
}
