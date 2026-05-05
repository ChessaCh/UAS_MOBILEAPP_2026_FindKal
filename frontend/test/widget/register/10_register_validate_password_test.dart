import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/user_auth/register.dart';


void main() {
  group('RegisterPage - Validasi password (_validatePassword)', () {
    Widget buildRegisterPage() {
      return const MaterialApp(
        home: RegisterPage(),
      );
    }

    // Helper: field password ada di index ke-2
    Future<void> enterPassword(WidgetTester tester, String value) async {
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(2), value);
      await tester.pump();
    }

    testWidgets('Tidak ada pesan error ketika field password masih kosong',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      // Tidak ada error di awal
      expect(find.text('Password harus minimal 8 karakter.'), findsNothing);
    });

    testWidgets('Muncul error jika password kurang dari 8 karakter',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      await enterPassword(tester, 'Ab1!');

      expect(find.text('Password harus minimal 8 karakter.'), findsOneWidget);
    });

    testWidgets('Muncul error jika password tidak ada huruf besar',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      await enterPassword(tester, 'password1!');

      expect(
        find.text('Password harus memiliki karakter huruf besar.'),
        findsOneWidget,
      );
    });

    testWidgets('Muncul error jika password tidak ada huruf kecil',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      await enterPassword(tester, 'PASSWORD1!');

      expect(
        find.text('Password harus memiliki karakter huruf kecil.'),
        findsOneWidget,
      );
    });

    testWidgets('Muncul error jika password tidak ada angka',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      await enterPassword(tester, 'Password!');

      expect(
        find.text('Password harus memiliki angka.'),
        findsOneWidget,
      );
    });

    testWidgets('Muncul error jika password tidak ada karakter spesial',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      await enterPassword(tester, 'Password1');

      expect(
        find.text('Password harus memiliki karakter spesial.'),
        findsOneWidget,
      );
    });

    testWidgets('Tidak ada error jika password memenuhi semua syarat',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      await enterPassword(tester, 'Password1!');

      // Tidak ada pesan error apapun
      expect(find.text('Password harus minimal 8 karakter.'), findsNothing);
      expect(find.text('Password harus memiliki karakter huruf besar.'), findsNothing);
      expect(find.text('Password harus memiliki karakter huruf kecil.'), findsNothing);
      expect(find.text('Password harus memiliki angka.'), findsNothing);
      expect(find.text('Password harus memiliki karakter spesial.'), findsNothing);
    });

    testWidgets('Pesan error berubah secara real-time saat input berubah',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      // Awalnya kurang dari 8 karakter
      await enterPassword(tester, 'Ab1!');
      expect(find.text('Password harus minimal 8 karakter.'), findsOneWidget);

      // Setelah diperpanjang, error berubah
      await enterPassword(tester, 'password1!');
      expect(find.text('Password harus minimal 8 karakter.'), findsNothing);
      expect(find.text('Password harus memiliki karakter huruf besar.'), findsOneWidget);
    });

    testWidgets('Error tidak muncul saat field password kembali dikosongkan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      await enterPassword(tester, 'Ab1');
      expect(find.text('Password harus minimal 8 karakter.'), findsOneWidget);

      // Kosongkan lagi
      await enterPassword(tester, '');
      expect(find.text('Password harus minimal 8 karakter.'), findsNothing);
    });

    testWidgets('Pesan error ditampilkan dengan warna merah',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      await enterPassword(tester, 'short');

      final errorText = tester.widget<Text>(
        find.text('Password harus minimal 8 karakter.'),
      );
      expect(errorText.style?.color, Colors.red);
    });

    testWidgets('Field password memiliki toggle visibility',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });
}