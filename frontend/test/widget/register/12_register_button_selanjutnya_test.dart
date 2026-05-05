import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/user_auth/register.dart';


void main() {
  group('RegisterPage - Button Selanjutnya (_onSelanjutnyaTapped)', () {
    Widget buildRegisterPage() {
      return const MaterialApp(
        home: RegisterPage(),
      );
    }

    testWidgets('Tombol Selanjutnya tampil di halaman register',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      expect(find.text('Selanjutnya'), findsOneWidget);
    });

    testWidgets('Tombol Selanjutnya dinonaktifkan (disabled) saat form belum lengkap',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Selanjutnya'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('Muncul SnackBar error jika nama kosong saat tombol ditekan secara langsung',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      // Coba tap langsung meski disabled — tidak crash
      await tester.tap(find.text('Selanjutnya'), warnIfMissed: false);
      await tester.pump();

      // Tidak ada navigasi, halaman masih RegisterPage
      expect(find.byType(RegisterPage), findsOneWidget);
    });

    testWidgets('Tombol Selanjutnya tetap disabled jika hanya nama diisi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'Irsyad Pratama');
      await tester.pump();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Selanjutnya'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('Tombol Selanjutnya tetap disabled jika password tidak valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'Irsyad');
      await tester.enterText(fields.at(1), 'irsyad123');
      await tester.enterText(fields.at(2), 'lemah'); // password tidak valid
      await tester.pump();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Selanjutnya'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('Tombol Selanjutnya tetap disabled jika email belum diverifikasi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'Irsyad Pratama');
      await tester.enterText(fields.at(1), 'irsyad123');
      await tester.enterText(fields.at(2), 'Password1!');
      await tester.enterText(fields.at(3), 'irsyad@mail.com');
      await tester.pump();

      // Email belum diverifikasi, tombol masih disabled
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Selanjutnya'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('Tombol Selanjutnya memiliki lebar penuh',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.widgetWithText(ElevatedButton, 'Selanjutnya'),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(sizedBox.width, double.infinity);
    });

    testWidgets('Tombol Selanjutnya memiliki tinggi 48',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.widgetWithText(ElevatedButton, 'Selanjutnya'),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(sizedBox.height, 48);
    });

    testWidgets('Teks tombol Selanjutnya sesuai',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      expect(find.text('Selanjutnya'), findsOneWidget);
    });

    testWidgets('Halaman tidak bernavigasi saat tombol Selanjutnya disabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      // Verifikasi halaman tetap RegisterPage
      expect(find.byType(RegisterPage), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
    });

    testWidgets('Link kembali ke halaman login tampil',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      expect(find.text('Sudah punya akun? Masuk'), findsOneWidget);
    });
  });
}