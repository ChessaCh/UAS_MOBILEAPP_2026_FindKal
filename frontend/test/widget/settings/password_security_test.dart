import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:findkal/settingpage/password_security_page.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  group('PasswordSecurityPage - Widget Test', () {
    setUp(() {
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test User',
        'email': 'user@mail.com',
      };
    });

    tearDown(() {
      AuthState.currentUser = null;
    });

    Widget buildWidget() {
      return const MaterialApp(
        home: PasswordSecurityPage(),
      );
    }

    testWidgets('Menampilkan AppBar dengan judul "Password & Keamanan"',
        (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Password & Keamanan'), findsOneWidget);
    });

    testWidgets('Menampilkan label alamat email', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Alamat email'), findsOneWidget);
    });

    testWidgets('Menampilkan label kata sandi', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Kata sandi'), findsOneWidget);
    });

    testWidgets('Menampilkan menu item "Hapus akun"', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Hapus akun'), findsOneWidget);
    });

    testWidgets(
        'Tap "Hapus akun" membuka dialog konfirmasi hapus akun',
        (tester) async {
      await tester.pumpWidget(buildWidget());

      await tester.tap(find.text('Hapus akun'));
      await tester.pumpAndSettle();

      expect(find.text('Yakin untuk hapus akun kamu?'), findsOneWidget);
    });

    testWidgets('Dialog hapus akun menampilkan nama dan email pengguna',
        (tester) async {
      await tester.pumpWidget(buildWidget());

      await tester.tap(find.text('Hapus akun'));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.text('Test User'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.text('user@mail.com'),
        ),
        findsOneWidget,
      );
    });
  });
}