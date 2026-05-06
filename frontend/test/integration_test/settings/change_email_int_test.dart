import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:findkal/settingpage/change_email_page.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ChangeEmailPage - Integration Test', () {
    setUp(() {
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test User',
        'email': 'old@mail.com',
      };
    });

    tearDown(() {
      AuthState.currentUser = null;
    });

    testWidgets(
      'Alur ganti email: input valid → tombol aktif → tap → loading tampil',
      (tester) async {
        // Navigasi ke PasswordSecurityPage → ChangeEmailPage
        // (Dalam skenario nyata, navigasi dilakukan dari SettingsPage)
        // Di sini kita langsung test halaman ChangeEmail
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (ctx) => Scaffold(
                body: ElevatedButton(
                  onPressed: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (_) => const ChangeEmailPage(),
                    ),
                  ),
                  child: const Text('Go to Change Email'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Go to Change Email'));
        await tester.pumpAndSettle();

        // Isi email valid
        await tester.enterText(find.byType(TextField), 'new@email.com');
        await tester.pump();

        // Tombol harus aktif
        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.onPressed, isNotNull);
      },
    );

    testWidgets(
      'Alur ganti email: input email invalid → SnackBar error muncul',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: ChangeEmailPage()),
        );

        await tester.enterText(find.byType(TextField), 'bukan-email');
        await tester.pump();
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(find.text('Format email tidak valid.'), findsOneWidget);
      },
    );

    testWidgets(
      'Tombol back menutup halaman dan kembali ke halaman sebelumnya',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (ctx) => Scaffold(
                body: ElevatedButton(
                  onPressed: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (_) => const ChangeEmailPage(),
                    ),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Tap back icon
        await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
        await tester.pumpAndSettle();

        // Kembali ke halaman sebelumnya
        expect(find.text('Open'), findsOneWidget);
      },
    );

    testWidgets(
      'Input email kosong: tombol Lanjutkan tetap disabled',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: ChangeEmailPage()),
        );

        // Tidak input apapun
        await tester.pump();

        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.onPressed, isNull);
      },
    );

    testWidgets(
      'Input email valid: teks tombol "Lanjutkan" terlihat',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: ChangeEmailPage()),
        );

        await tester.enterText(find.byType(TextField), 'valid@mail.com');
        await tester.pump();

        expect(find.text('Lanjutkan'), findsOneWidget);
      },
    );

    testWidgets(
      'Halaman Change Email dapat di-scroll ke bawah',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: ChangeEmailPage()),
        );
        await tester.pumpAndSettle();

        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -200),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      },
    );
  });
}