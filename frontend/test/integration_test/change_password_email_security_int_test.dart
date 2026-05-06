import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:findkal/settingpage/password_security_page.dart';
import 'package:findkal/settingpage/change_email_page.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('PasswordSecurityPage - Integration Test', () {
    setUp(() {
      AuthState.currentUser = {
        'id': 1,
        'name': 'Dewi Rahayu',
        'email': 'dewi@mail.com',
      };
    });

    tearDown(() {
      AuthState.currentUser = null;
    });

    Widget buildApp() => const MaterialApp(home: PasswordSecurityPage());

    testWidgets(
      'Tap edit alamat email → navigasi ke ChangeEmailPage',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        expect(find.text('Alamat email'), findsOneWidget);
        await tester.tap(find.text('Edit').first);
        await tester.pumpAndSettle();

        // Halaman ChangeEmailPage terbuka
        expect(find.byType(ChangeEmailPage), findsOneWidget);
      },
    );

    testWidgets(
      'Tap "Hapus akun" → dialog konfirmasi muncul dengan nama dan email',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Hapus akun'));
        await tester.pumpAndSettle();

        expect(find.text('Yakin untuk hapus akun kamu?'), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(Dialog),
            matching: find.text('Dewi Rahayu'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byType(Dialog),
            matching: find.text('dewi@mail.com'),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Dialog konfirmasi: tap "Batalkan" → dialog ditutup',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Hapus akun'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Batalkan'));
        await tester.pumpAndSettle();

        expect(find.text('Yakin untuk hapus akun kamu?'), findsNothing);
      },
    );

    testWidgets(
      'Halaman menampilkan AppBar "Password & Keamanan"',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        expect(find.text('Password & Keamanan'), findsOneWidget);
      },
    );

    testWidgets(
      'Back button menutup PasswordSecurityPage',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (ctx) => Scaffold(
                body: ElevatedButton(
                  onPressed: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (_) => const PasswordSecurityPage(),
                    ),
                  ),
                  child: const Text('Open Password Security'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open Password Security'));
        await tester.pumpAndSettle();

        expect(find.byType(PasswordSecurityPage), findsOneWidget);

        // Tap back
        await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
        await tester.pumpAndSettle();

        expect(find.byType(PasswordSecurityPage), findsNothing);
      },
    );

    testWidgets(
      'Semua tiga menu item ditampilkan sekaligus',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        expect(find.text('Alamat email'), findsOneWidget);
        expect(find.text('Kata sandi'), findsOneWidget);
        expect(find.text('Hapus akun'), findsOneWidget);
      },
    );
  });
}