import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/user_auth/enter_code.dart';

void main() {
  group('EnterCodePage - Input OTP code', () {
    Widget buildEnterCodePage({EnterCodeMode mode = EnterCodeMode.passwordReset}) {
      return MaterialApp(
        home: EnterCodePage(
          email: 'irsyad@example.com',
          mode: mode,
        ),
      );
    }

    testWidgets('Halaman EnterCodePage berhasil dirender',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      expect(find.byType(EnterCodePage), findsOneWidget);
    });

    testWidgets('Judul "Cek pesan kamu" tampil',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      expect(find.text('Cek pesan kamu'), findsOneWidget);
    });

    testWidgets('Email yang dikirim tampil dalam deskripsi halaman',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      expect(find.textContaining('irsyad@example.com'), findsOneWidget);
    });

    testWidgets('Terdapat 6 TextField untuk input OTP',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(6));
    });

    testWidgets('Setiap field OTP menerima input 1 digit angka',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), '1');
      await tester.pump();

      final firstField = tester.widget<TextField>(fields.at(0));
      expect(firstField.controller?.text, '1');
    });

    testWidgets('Semua 6 field OTP bisa diisi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      for (int i = 0; i < 6; i++) {
        await tester.enterText(fields.at(i), '$i');
        await tester.pump();
      }

      for (int i = 0; i < 6; i++) {
        final field = tester.widget<TextField>(fields.at(i));
        expect(field.controller?.text, '$i');
      }
    });

    testWidgets('Field OTP bertipe numerik (keyboardType number)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      final field = tester.widget<TextField>(find.byType(TextField).first);
      expect(field.keyboardType, TextInputType.number);
    });

    testWidgets('Teks alignment OTP di tengah (center)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      final field = tester.widget<TextField>(find.byType(TextField).first);
      expect(field.textAlign, TextAlign.center);
    });

    testWidgets('Terdapat teks "Tidak menerima kode?"',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      expect(find.text('Tidak menerima kode?'), findsOneWidget);
    });

    testWidgets('Terdapat link "Kirim kode baru"',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      expect(find.text('Kirim kode baru'), findsOneWidget);
    });

    testWidgets('Terdapat AppBar dengan tombol kembali',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });

    testWidgets('Pesan mode passwordReset berbeda dengan mode registrasi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage(mode: EnterCodeMode.passwordReset));
      await tester.pumpAndSettle();
      expect(find.textContaining('mengatur ulang kata sandi'), findsOneWidget);

      await tester.pumpWidget(buildEnterCodePage(mode: EnterCodeMode.registration));
      await tester.pumpAndSettle();
      expect(find.textContaining('konfirmasi akun'), findsOneWidget);
    });

    testWidgets('Semua field OTP kosong saat halaman pertama dibuka',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildEnterCodePage());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      for (int i = 0; i < 6; i++) {
        final field = tester.widget<TextField>(fields.at(i));
        expect(field.controller?.text ?? '', isEmpty);
      }
    });
  });
}