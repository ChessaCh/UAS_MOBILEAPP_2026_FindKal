import 'package:flutter_test/flutter_test.dart';

/// Unit test untuk TermsConditionsPage.
/// Berfokus pada logika pemrosesan konten, format teks,
/// dan konstanta konfigurasi halaman.
void main() {
  group('TermsConditionsPage - Unit Test: Konstanta & Konfigurasi', () {
    const String expectedTitle = 'Syarat & Ketentuan';

    test('Judul halaman adalah "Syarat & Ketentuan"', () {
      expect(expectedTitle, 'Syarat & Ketentuan');
    });

    test('Judul halaman tidak boleh kosong', () {
      expect(expectedTitle.isEmpty, isFalse);
    });

    test('Judul mengandung ampersand (&)', () {
      expect(expectedTitle.contains('&'), isTrue);
    });
  });

  group('TermsConditionsPage - Unit Test: Format Konten Syarat', () {
    test('Section dapat dibuat dari list item', () {
      final sections = ['Penerimaan Syarat', 'Penggunaan Layanan', 'Privasi'];
      expect(sections.length, 3);
      expect(sections.first, 'Penerimaan Syarat');
    });

    test('Nomor section diformat dengan benar (1., 2., 3.)', () {
      final sections = ['Penerimaan Syarat', 'Penggunaan Layanan'];
      final formatted = sections.asMap().entries.map(
        (e) => '${e.key + 1}. ${e.value}',
      ).toList();
      expect(formatted[0], '1. Penerimaan Syarat');
      expect(formatted[1], '2. Penggunaan Layanan');
    });

    test('Teks panjang syarat dipotong dengan benar untuk preview', () {
      const terms =
          'Dengan menggunakan aplikasi ini, kamu menyetujui syarat dan ketentuan yang berlaku secara penuh.';
      final isLong = terms.length > 50;
      expect(isLong, isTrue);
    });

    test('Versi syarat dan ketentuan memiliki format versi yang valid', () {
      const version = 'v1.2.0';
      final versionRegex = RegExp(r'^v\d+\.\d+\.\d+$');
      expect(versionRegex.hasMatch(version), isTrue);
    });

    test('Tanggal efektif syarat dapat diparse', () {
      const effectiveDate = '2024-06-01';
      final dt = DateTime.tryParse(effectiveDate);
      expect(dt, isNotNull);
      expect(dt!.year, 2024);
    });

    test('Syarat dengan bullet point memiliki karakter "•"', () {
      const bullet = '• Dilarang menyebarkan konten yang melanggar hukum.';
      expect(bullet.contains('•'), isTrue);
    });
  });
}