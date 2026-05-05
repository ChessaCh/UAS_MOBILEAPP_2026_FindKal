import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/user_auth/enter_code.dart';


void main() {
  group('EnterCodePage - Button Lanjutkan (_verifyCode)', () {
    Widget buildEnterCodePage({EnterCodeMode mode = EnterCodeMode.passwordReset}) {
      return MaterialApp(
        home: EnterCodePage(
          email: 'irsyad@example.com',
          mode: mode,
        ),
      );
    }

    testWidgets('Tombol Lanjutkan tampil di halaman OTP',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      expect(find.text('Lanjutkan'), findsOneWidget);
    });

    testWidgets('Tombol Lanjutkan bertipe ElevatedButton',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets(
        'Muncul SnackBar jika tombol Lanjutkan ditekan dengan semua field kosong',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Lanjutkan'));
      await tester.pump();

      expect(
        find.text('Masukkan 6 digit kode terlebih dahulu.'),
        findsOneWidget,
      );
    });

    testWidgets(
        'Muncul SnackBar jika hanya sebagian field OTP diisi (kurang dari 6)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      // Hanya isi 3 dari 6 field
      await tester.enterText(fields.at(0), '1');
      await tester.enterText(fields.at(1), '2');
      await tester.enterText(fields.at(2), '3');
      await tester.pump();

      await tester.tap(find.text('Lanjutkan'));
      await tester.pump();

      expect(
        find.text('Masukkan 6 digit kode terlebih dahulu.'),
        findsOneWidget,
      );
    });

    testWidgets('SnackBar validasi OTP berwarna gelap',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Lanjutkan'));
      await tester.pump();

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, const Color(0xFF4A4A4A));
    });

    testWidgets('SnackBar validasi muncul dengan behavior floating',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Lanjutkan'));
      await tester.pump();

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.behavior, SnackBarBehavior.floating);
    });

    testWidgets('Tombol Lanjutkan aktif (enabled) saat halaman dibuka',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('Tidak ada SnackBar sebelum tombol Lanjutkan ditekan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('Tombol Lanjutkan memiliki lebar penuh',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(sizedBox.width, double.infinity);
    });

    testWidgets('Teks tombol Lanjutkan sesuai',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(
        find.descendant(
          of: find.byType(ElevatedButton),
          matching: find.byType(Text),
        ),
      );
      expect(textWidget.data, 'Lanjutkan');
    });

    testWidgets('Tidak ada SnackBar validasi jika semua 6 field OTP terisi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      for (int i = 0; i < 6; i++) {
        await tester.enterText(fields.at(i), '$i');
      }
      await tester.pump();

      // SnackBar "6 digit" tidak muncul (meski mungkin ada error API)
      expect(
        find.text('Masukkan 6 digit kode terlebih dahulu.'),
        findsNothing,
      );
    });

    testWidgets('Tombol Lanjutkan memiliki tinggi 48',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(sizedBox.height, 48);
    });
  });
}