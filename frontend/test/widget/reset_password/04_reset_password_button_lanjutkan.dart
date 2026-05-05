import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/user_auth/reset_password.dart';


void main() {
  group('ResetPasswordPage - Button Lanjutkan (_onLanjutkanTapped)', () {
    Widget buildResetPasswordPage() {
      return const MaterialApp(
        home: ResetPasswordPage(),
      );
    }

    testWidgets('Tombol Lanjutkan tampil di halaman',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildResetPasswordPage());
      await tester.pumpAndSettle();

      expect(find.text('Lanjutkan'), findsOneWidget);
    });

    testWidgets('Tombol Lanjutkan bertipe ElevatedButton',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildResetPasswordPage());
      await tester.pumpAndSettle();

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets(
        'Muncul SnackBar peringatan jika tombol Lanjutkan ditekan dengan field kosong',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildResetPasswordPage());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Lanjutkan'));
      await tester.pump();

      expect(
        find.text('Masukkan username atau email terlebih dahulu.'),
        findsOneWidget,
      );
    });

    testWidgets('SnackBar validasi kosong berwarna gelap (bukan merah)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildResetPasswordPage());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Lanjutkan'));
      await tester.pump();

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, const Color(0xFF4A4A4A));
    });

    testWidgets('Tombol Lanjutkan aktif (enabled) saat halaman baru dibuka',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildResetPasswordPage());
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('Tombol Lanjutkan tidak mengalami error saat ditekan berulang dengan input kosong',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildResetPasswordPage());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Lanjutkan'));
      await tester.pump();
      await tester.tap(find.text('Lanjutkan'));
      await tester.pump();

      // Tidak ada exception, SnackBar masih ada
      expect(find.byType(SnackBar), findsWidgets);
    });

    testWidgets('Tidak muncul SnackBar validasi jika input sudah diisi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildResetPasswordPage());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'irsyad@mail.com');
      await tester.pump();

      // Belum ditekan, SnackBar belum muncul
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('Tombol Lanjutkan memiliki ukuran tinggi 48',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildResetPasswordPage());
      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(sizedBox.height, 48);
    });

    testWidgets('SnackBar muncul dengan behavior floating',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildResetPasswordPage());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Lanjutkan'));
      await tester.pump();

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.behavior, SnackBarBehavior.floating);
    });

    testWidgets('Teks tombol Lanjutkan terlihat jelas',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildResetPasswordPage());
      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(
        find.descendant(
          of: find.byType(ElevatedButton),
          matching: find.byType(Text),
        ),
      );
      expect(textWidget.data, 'Lanjutkan');
    });

    testWidgets('Tombol memiliki lebar penuh (full width)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildResetPasswordPage());
      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(sizedBox.width, double.infinity);
    });

    testWidgets('Tombol back AppBar dapat ditekan tanpa error',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ResetPasswordPage(),
                    ),
                  );
                },
                child: const Text('Go'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle();
    });
  });
}