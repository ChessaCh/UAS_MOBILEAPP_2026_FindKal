import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/user_auth/create_new_password.dart';

void main() {
  group('CreateNewPasswordPage - Button Lanjutkan (_onLanjutkanTapped)', () {
    Widget buildPage() {
      return const MaterialApp(
        home: CreateNewPasswordPage(resetToken: 'dummy_token_123'),
      );
    }

    Future<void> fillPasswords(
      WidgetTester tester, {
      required String password,
      required String confirm,
    }) async {
      final fields = find.byType(TextField);
      await tester.enterText(fields.first, password);
      await tester.enterText(fields.last, confirm);
      await tester.pump();
    }

    testWidgets('Tombol Lanjutkan tampil di halaman',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      expect(find.text('Lanjutkan'), findsOneWidget);
    });

    testWidgets('Muncul SnackBar jika kedua field kosong',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Lanjutkan'));
      await tester.pump();

      expect(find.text('Lengkapi semua kolom terlebih dahulu.'), findsOneWidget);
    });

    testWidgets('Muncul SnackBar jika password kurang dari 8 karakter',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      await fillPasswords(tester, password: 'Ab1!', confirm: 'Ab1!');

      await tester.tap(find.text('Lanjutkan'));
      await tester.pump();

      expect(
        find.text('Kata sandi terlalu pendek. Harus minimal 8 karakter.'),
        findsOneWidget,
      );
    });

    testWidgets('Muncul SnackBar jika password tidak memiliki huruf besar',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      await fillPasswords(tester, password: 'password1!', confirm: 'password1!');

      await tester.tap(find.text('Lanjutkan'));
      await tester.pump();

      expect(
        find.text('Kata sandi harus memiliki setidaknya satu huruf besar.'),
        findsOneWidget,
      );
    });

    testWidgets('Muncul SnackBar jika password tidak memiliki huruf kecil',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      await fillPasswords(tester, password: 'PASSWORD1!', confirm: 'PASSWORD1!');

      await tester.tap(find.text('Lanjutkan'));
      await tester.pump();

      expect(
        find.text('Kata sandi harus memiliki setidaknya satu huruf kecil.'),
        findsOneWidget,
      );
    });

    testWidgets('Muncul SnackBar jika password tidak memiliki angka',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      await fillPasswords(tester, password: 'Password!', confirm: 'Password!');

      await tester.tap(find.text('Lanjutkan'));
      await tester.pump();

      expect(
        find.text('Kata sandi harus memiliki setidaknya satu angka.'),
        findsOneWidget,
      );
    });

    testWidgets('Muncul SnackBar jika password tidak memiliki karakter spesial',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      await fillPasswords(tester, password: 'Password1', confirm: 'Password1');

      await tester.tap(find.text('Lanjutkan'));
      await tester.pump();

      expect(
        find.text('Kata sandi harus memiliki setidaknya satu karakter spesial.'),
        findsOneWidget,
      );
    });

    testWidgets('Muncul SnackBar jika password dan konfirmasi tidak cocok',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      await fillPasswords(
        tester,
        password: 'Password1!',
        confirm: 'Password2!',
      );

      await tester.tap(find.text('Lanjutkan'));
      await tester.pump();

      expect(find.text('Kata sandi tidak cocok.'), findsOneWidget);
    });

    testWidgets('SnackBar "tidak cocok" berwarna merah',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      await fillPasswords(
        tester,
        password: 'Password1!',
        confirm: 'DifferentPass1!',
      );
      await tester.tap(find.text('Lanjutkan'));
      await tester.pump();

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, Colors.redAccent);
    });

    testWidgets('Tombol Lanjutkan aktif dan bisa ditekan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('Tidak ada SnackBar sebelum tombol ditekan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('SnackBar validasi muncul dengan behavior floating',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Lanjutkan'));
      await tester.pump();

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.behavior, SnackBarBehavior.floating);
    });
  });
}