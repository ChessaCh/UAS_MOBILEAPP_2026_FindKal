import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/user_auth/login.dart';


void main() {
  group('LoginPage - Input username/email dan password', () {
    Widget buildLoginPage() {
      return const MaterialApp(
        home: LoginPage(),
      );
    }

    testWidgets('Halaman Login berhasil dirender tanpa error',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('Terdapat field input username atau email',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();
      // Cari label teks username/email
      expect(find.text('Username atau Email'), findsOneWidget);
    });

    testWidgets('Terdapat field input kata sandi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();
      expect(find.text('Kata sandi'), findsOneWidget);
    });

    testWidgets('Terdapat dua TextField di halaman login',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('Field username/email dapat menerima input teks',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      await tester.tap(textFields.first);
      await tester.enterText(textFields.first, 'irsyad@example.com');
      await tester.pump();

      expect(find.text('irsyad@example.com'), findsOneWidget);
    });

    testWidgets('Field password dapat menerima input teks',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      await tester.tap(textFields.last);
      await tester.enterText(textFields.last, 'Password123!');
      await tester.pump();

      // Password field menerima input (walaupun diobscure)
      final TextField passwordField = tester.widget(textFields.last);
      expect(passwordField.controller?.text, 'Password123!');
    });

    testWidgets('Field username menerima input berupa username (bukan email)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'irsyad_user');
      await tester.pump();

      expect(find.text('irsyad_user'), findsOneWidget);
    });

    testWidgets('Field password secara default dalam mode obscure (tersembunyi)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      final TextField passwordField = tester.widget(textFields.last);
      expect(passwordField.obscureText, isTrue);
    });

    testWidgets('Terdapat icon toggle visibility pada field password',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      // Cek ada icon visibility_off (default state)
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('Icon visibility berubah saat ditekan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      // Tekan icon visibility_off
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      // Setelah ditekan, icon berubah menjadi visibility
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('Field password tidak obscure setelah toggle ditekan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      final textFields = find.byType(TextField);
      final TextField passwordField = tester.widget(textFields.last);
      expect(passwordField.obscureText, isFalse);
    });

    testWidgets('Terdapat teks selamat datang di halaman login',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      expect(find.text('Selamat Datang!'), findsOneWidget);
    });

    testWidgets('Terdapat link lupa kata sandi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      expect(find.text('Lupa Kata Sandi?'), findsOneWidget);
    });

    testWidgets('Terdapat link daftar akun baru',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      expect(find.text('Belum punya akun? Daftar sekarang!'), findsOneWidget);
    });
  });
}