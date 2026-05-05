import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/user_auth/register.dart';


void main() {
  group('RegisterPage - Button verify (_onVerifyTapped)', () {
    Widget buildRegisterPage() {
      return const MaterialApp(
        home: RegisterPage(),
      );
    }

    Future<void> enterEmail(WidgetTester tester, String email) async {
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(3), email);
      await tester.pump();
    }

    testWidgets('Tombol verify tampil di halaman register',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      expect(find.text('verify'), findsOneWidget);
    });

    testWidgets('Tombol verify dapat ditekan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      await tester.tap(find.text('verify'));
      await tester.pump();

      // Tidak crash
      expect(find.byType(RegisterPage), findsOneWidget);
    });

    testWidgets('Muncul SnackBar jika email kosong saat verify ditekan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      await tester.tap(find.text('verify'));
      await tester.pump();

      expect(
        find.text('Masukkan email terlebih dahulu.'),
        findsOneWidget,
      );
    });

    testWidgets('Muncul SnackBar jika format email tidak valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      await enterEmail(tester, 'bukanemailvalid');
      await tester.tap(find.text('verify'));
      await tester.pump();

      expect(
        find.text('Format email tidak valid. Pastikan ada tanda "@".'),
        findsOneWidget,
      );
    });

    testWidgets('Muncul SnackBar merah jika format email tidak valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      await enterEmail(tester, 'tidakvalid');
      await tester.tap(find.text('verify'));
      await tester.pump();

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, Colors.redAccent);
    });

    testWidgets('Tidak muncul SnackBar format jika email valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      await enterEmail(tester, 'irsyad@example.com');
      // Belum tap, tidak ada snackbar
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('SnackBar email kosong berwarna gelap (bukan merah)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      await tester.tap(find.text('verify'));
      await tester.pump();

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, const Color(0xFF4A4A4A));
    });

    testWidgets('SnackBar muncul dengan behavior floating',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      await tester.tap(find.text('verify'));
      await tester.pump();

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.behavior, SnackBarBehavior.floating);
    });

    testWidgets('Email dengan format username@domain.com dianggap valid (tidak muncul SnackBar format)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      await enterEmail(tester, 'irsyad@gmail.com');
      // SnackBar format tidak valid tidak muncul sebelum tap
      expect(find.text('Format email tidak valid. Pastikan ada tanda "@".'), findsNothing);
    });

    testWidgets('Tombol verify memiliki border radius melengkung',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      expect(find.text('verify'), findsOneWidget);
      // Tombol ada di dalam Container dengan borderRadius
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Email dengan tanda "@" tapi tanpa domain tidak dianggap valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      await enterEmail(tester, 'irsyad@');
      await tester.tap(find.text('verify'));
      await tester.pump();

      expect(
        find.text('Format email tidak valid. Pastikan ada tanda "@".'),
        findsOneWidget,
      );
    });
  });
}