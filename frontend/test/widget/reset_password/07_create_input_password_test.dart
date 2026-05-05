import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/user_auth/create_new_password.dart';


void main() {
  group('CreateNewPasswordPage - Input password baru', () {
    Widget buildCreateNewPasswordPage() {
      return const MaterialApp(
        home: CreateNewPasswordPage(resetToken: 'dummy_token_123'),
      );
    }

    testWidgets('Halaman CreateNewPasswordPage berhasil dirender',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateNewPasswordPage());
      await tester.pumpAndSettle();

      expect(find.byType(CreateNewPasswordPage), findsOneWidget);
    });

    testWidgets('Judul "Buat kata sandi baru" tampil',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateNewPasswordPage());
      await tester.pumpAndSettle();

      expect(find.text('Buat kata sandi baru'), findsOneWidget);
    });

    testWidgets('Label "Kata sandi baru" tampil',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateNewPasswordPage());
      await tester.pumpAndSettle();

      expect(find.text('Kata sandi baru'), findsOneWidget);
    });

    testWidgets('Label "Konfirmasi kata sandi baru" tampil',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateNewPasswordPage());
      await tester.pumpAndSettle();

      expect(find.text('Konfirmasi kata sandi baru'), findsOneWidget);
    });

    testWidgets('Terdapat 2 TextField: password baru dan konfirmasi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateNewPasswordPage());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('Kedua field password secara default dalam mode obscure',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateNewPasswordPage());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      final first = tester.widget<TextField>(fields.first);
      final last = tester.widget<TextField>(fields.last);

      expect(first.obscureText, isTrue);
      expect(last.obscureText, isTrue);
    });

    testWidgets('Field password baru dapat menerima input',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateNewPasswordPage());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.tap(fields.first);
      await tester.enterText(fields.first, 'Password123!');
      await tester.pump();

      final field = tester.widget<TextField>(fields.first);
      expect(field.controller?.text, 'Password123!');
    });

    testWidgets('Field konfirmasi password dapat menerima input',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateNewPasswordPage());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.tap(fields.last);
      await tester.enterText(fields.last, 'Password123!');
      await tester.pump();

      final field = tester.widget<TextField>(fields.last);
      expect(field.controller?.text, 'Password123!');
    });

    testWidgets('Terdapat 2 icon toggle visibility (satu per field)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateNewPasswordPage());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));
    });

    testWidgets('Toggle visibility pada field password baru berfungsi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateNewPasswordPage());
      await tester.pumpAndSettle();

      final icons = find.byIcon(Icons.visibility_off);
      await tester.tap(icons.first);
      await tester.pump();

      // Setelah toggle, salah satu ikon berubah ke visibility
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('Toggle visibility pada field konfirmasi berfungsi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateNewPasswordPage());
      await tester.pumpAndSettle();

      final icons = find.byIcon(Icons.visibility_off);
      await tester.tap(icons.last);
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('Terdapat AppBar dengan tombol kembali',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateNewPasswordPage());
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });

    testWidgets('Deskripsi instruksi pembuatan password tampil',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateNewPasswordPage());
      await tester.pumpAndSettle();

      expect(find.textContaining('minimal 8 karakter'), findsOneWidget);
    });
  });
}