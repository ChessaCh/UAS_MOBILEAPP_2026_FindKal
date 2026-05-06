import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:findkal/user_auth/register_address.dart';
import '../../helpers/fake_regional_http_client.dart';

/// Integration Test — Register Address Flow
/// Tester: Arji
/// Menguji alur lengkap RegisterAddressPage:
/// load provinsi → pilih provinsi → load kota → pilih kota →
/// load kecamatan → pilih kecamatan → load kelurahan → pilih kelurahan →
/// tombol "Buat akun" aktif.

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => HttpOverrides.global = FakeRegionalHttpOverrides());
  tearDownAll(() => HttpOverrides.global = null);

  Widget buildPage() => MaterialApp(
        home: RegisterAddressPage(
          name: 'Arji Test',
          username: 'arji123',
          password: 'Password1!',
          email: 'arji@test.com',
        ),
      );

  group('Register Address - Alur Lengkap', () {
    testWidgets(
        'Halaman RegisterAddressPage berhasil dimuat dengan data provinsi',
        (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      expect(find.text('Sign up'), findsOneWidget);
      expect(find.text('Indonesia'), findsOneWidget);
    });

    testWidgets('Dropdown provinsi berisi data setelah halaman dibuka',
        (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownButton<String>).first);
      await tester.pumpAndSettle();

      // Mock returns "Aceh" and "Sumatera Utara"
      expect(find.text('Aceh'), findsWidgets);
    });

    testWidgets('Memilih provinsi memuat daftar kota', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      // Pilih provinsi
      await tester.tap(find.byType(DropdownButton<String>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aceh').last);
      await tester.pumpAndSettle();

      // Buka dropdown kota — harus ada data dari mock
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();

      expect(find.text('Banda Aceh'), findsWidgets);
    });

    testWidgets('Memilih kota memuat daftar kecamatan', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownButton<String>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aceh').last);
      await tester.pumpAndSettle();

      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Banda Aceh').last);
      await tester.pumpAndSettle();

      // Kecamatan dropdown should now have data
      await tester.tap(find.byType(DropdownButton<String>).at(2));
      await tester.pumpAndSettle();

      expect(find.text('Baiturrahman'), findsWidgets);
    });

    testWidgets('Memilih kecamatan memuat daftar kelurahan', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownButton<String>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aceh').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownButton<String>).at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Banda Aceh').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownButton<String>).at(2));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Baiturrahman').last);
      await tester.pumpAndSettle();

      // Kelurahan dropdown should now have data
      await tester.tap(find.byType(DropdownButton<String>).at(3));
      await tester.pumpAndSettle();

      expect(find.text('Ateuk Jawo'), findsWidgets);
    });

    testWidgets(
        'Tombol "Buat akun" aktif setelah semua alamat dipilih',
        (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      // Pilih provinsi
      await tester.tap(find.byType(DropdownButton<String>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aceh').last);
      await tester.pumpAndSettle();

      // Pilih kota
      await tester.tap(find.byType(DropdownButton<String>).at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Banda Aceh').last);
      await tester.pumpAndSettle();

      // Pilih kecamatan
      await tester.tap(find.byType(DropdownButton<String>).at(2));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Baiturrahman').last);
      await tester.pumpAndSettle();

      // Pilih kelurahan
      await tester.tap(find.byType(DropdownButton<String>).at(3));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ateuk Jawo').last);
      await tester.pumpAndSettle();

      // Tombol harus aktif
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Buat akun'),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('Tombol "Buat akun" nonaktif sebelum semua alamat dipilih',
        (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Buat akun'),
      );
      expect(button.onPressed, isNull);
    });
  });
}
