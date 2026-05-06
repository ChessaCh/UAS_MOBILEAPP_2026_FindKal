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

    testWidgets('Menampilkan menu item "Ubah Email"', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Ubah Email'), findsOneWidget);
    });

    testWidgets('Menampilkan menu item "Ubah Password"', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Ubah Password'), findsOneWidget);
    });

    testWidgets('Menampilkan menu item "Hapus Akun"', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Hapus Akun'), findsOneWidget);
    });

    testWidgets(
        'Tap "Hapus Akun" membuka dialog konfirmasi hapus akun',
        (tester) async {
      await tester.pumpWidget(buildWidget());

      await tester.tap(find.text('Hapus Akun'));
      await tester.pumpAndSettle();

      expect(find.text('Yakin untuk hapus akun kamu?'), findsOneWidget);
    });

    testWidgets('Dialog hapus akun menampilkan nama dan email pengguna',
        (tester) async {
      await tester.pumpWidget(buildWidget());

      await tester.tap(find.text('Hapus Akun'));
      await tester.pumpAndSettle();

      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('user@mail.com'), findsOneWidget);
    });
  });
}