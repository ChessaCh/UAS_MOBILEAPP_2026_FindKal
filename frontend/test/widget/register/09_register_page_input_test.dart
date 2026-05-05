import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/user_auth/register.dart';

void main() {
  group('RegisterPage - Input nama lengkap, username, password, email', () {
    Widget buildRegisterPage() {
      return const MaterialApp(
        home: RegisterPage(),
      );
    }

    testWidgets('Halaman RegisterPage berhasil dirender tanpa error',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      expect(find.byType(RegisterPage), findsOneWidget);
    });

    testWidgets('Judul "Sign up" tampil',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      expect(find.text('Sign up'), findsOneWidget);
    });

    testWidgets('Label "Nama lengkap" tampil',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      expect(find.text('Nama lengkap'), findsOneWidget);
    });

    testWidgets('Label "Username" tampil',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      expect(find.text('Username'), findsOneWidget);
    });

    testWidgets('Label "Password" tampil',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('Label "Email" tampil',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('Terdapat minimal 4 TextField (nama, username, password, email)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsAtLeastNWidgets(4));
    });

    testWidgets('Field nama lengkap dapat menerima input',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'Irsyad Pratama');
      await tester.pump();

      expect(find.text('Irsyad Pratama'), findsOneWidget);
    });

    testWidgets('Field username dapat menerima input',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(1), 'irsyad123');
      await tester.pump();

      expect(find.text('irsyad123'), findsOneWidget);
    });

    testWidgets('Field password dapat menerima input',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(2), 'Password123!');
      await tester.pump();

      final passwordField = tester.widget<TextField>(fields.at(2));
      expect(passwordField.controller?.text, 'Password123!');
    });

    testWidgets('Field password secara default dalam mode obscure',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      // Field password adalah index ke-2
      final fields = find.byType(TextField);
      final passwordField = tester.widget<TextField>(fields.at(2));
      expect(passwordField.obscureText, isTrue);
    });

    testWidgets('Field email menggunakan keyboard type email',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      // Email field adalah yang ke-3 (index 3)
      final emailField = tester.widget<TextField>(fields.at(3));
      expect(emailField.keyboardType, TextInputType.emailAddress);
    });

    testWidgets('Terdapat tombol verify untuk email',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      expect(find.text('verify'), findsOneWidget);
    });

    testWidgets('Terdapat link "Sudah punya akun? Masuk"',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      expect(find.text('Sudah punya akun? Masuk'), findsOneWidget);
    });
  });
}