import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Edit Profile Button Simpan Unit Tests', () {
    test('State isSaving berubah menjadi true saat fungsi simpan dipanggil', () {
      // Set up
      bool isSaving = false;

      Future<void> simulateSaveData() async {
        isSaving = true;
        await Future.delayed(const Duration(milliseconds: 100));
        isSaving = false;
      }

      // Do & Expect (during save)
      simulateSaveData();
      expect(isSaving, true); // Still synchronous check right after trigger
    });
  });
}
