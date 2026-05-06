import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/user_auth/register_address.dart';
import '../../helpers/fake_regional_http_client.dart';

/// Test File 17 — Widget: RegisterAddressPage
/// Tester: Arji
/// Memastikan class RegisterAddressPage merender dengan benar:
/// judul "Sign up", field negara "Indonesia", dropdown provinsi/kota/kecamatan/kelurahan,
/// dan tombol "Buat akun" tampil sesuai desain.

void main() {
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

  group('RegisterAddressPage - Render Halaman', () {
    testWidgets('Halaman RegisterAddressPage berhasil dirender tanpa error',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();

      expect(find.byType(RegisterAddressPage), findsOneWidget);
    });

    testWidgets('Judul "Sign up" tampil di halaman',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();

      expect(find.text('Sign up'), findsOneWidget);
    });

    testWidgets('Field negara menampilkan nilai "Indonesia" yang tidak dapat diubah',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();

      expect(find.text('Negara'), findsOneWidget);
      expect(find.text('Indonesia'), findsOneWidget);
    });

    testWidgets('Label "Provinsi" tampil',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();

      expect(find.text('Provinsi'), findsOneWidget);
    });

    testWidgets('Label "Kota" tampil',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();

      expect(find.text('Kota'), findsOneWidget);
    });

    testWidgets('Label "Kecamatan" tampil',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();

      expect(find.text('Kecamatan'), findsOneWidget);
    });

    testWidgets('Label "Kelurahan" tampil',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();

      expect(find.text('Kelurahan'), findsOneWidget);
    });

    testWidgets('Tombol "Buat akun" tampil di halaman',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();

      expect(find.text('Buat akun'), findsOneWidget);
    });

    testWidgets('Tombol "Buat akun" dinonaktifkan sebelum semua pilihan dipilih',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Buat akun'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('AppBar memiliki tombol kembali',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();

      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('Terdapat setidaknya 4 DropdownButton di halaman',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      expect(find.byType(DropdownButton<String>), findsAtLeastNWidgets(4));
    });

    testWidgets('Setelah loading selesai, dropdown Provinsi berisi data',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      // Tap province dropdown to open it
      final provinsiDropdowns = find.byType(DropdownButton<String>);
      await tester.tap(provinsiDropdowns.first);
      await tester.pumpAndSettle();

      // Mock returns "Aceh" and "Sumatera Utara"
      expect(find.text('Aceh'), findsWidgets);
    });
  });
}
