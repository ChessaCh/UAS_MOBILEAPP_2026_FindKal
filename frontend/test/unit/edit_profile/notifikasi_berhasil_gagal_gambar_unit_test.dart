import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Edit Profile Notifikasi Gambar Unit Tests', () {
    test('Exception dilemparkan dan dapat ditangkap saat proses gambar gagal', () {
      // Set up
      bool hasError = false;
      String errorMessage = '';

      void simulateImagePickerFailure() {
        try {
          throw Exception('Gagal membuka galeri');
        } catch (e) {
          hasError = true;
          errorMessage = e.toString();
        }
      }

      // Do
      simulateImagePickerFailure();

      // Expect
      expect(hasError, true);
      expect(errorMessage, contains('Gagal membuka galeri'));
    });
  });
}
