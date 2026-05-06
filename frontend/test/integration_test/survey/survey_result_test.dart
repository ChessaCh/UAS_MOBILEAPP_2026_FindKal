import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:findkal/settingpage/survey_result_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('SurveyResultPage - Integration Test', () {
    Widget buildPassed() => MaterialApp(
          home: SurveyResultPage(
            result: {
              'passed': true,
              'score': 5,
              'attempts_remaining': 0,
              'locked_until': null,
            },
          ),
        );

    Widget buildFailed({int score = 2, int attempts = 2}) => MaterialApp(
          home: SurveyResultPage(
            result: {
              'passed': false,
              'score': score,
              'attempts_remaining': attempts,
              'locked_until': null,
            },
          ),
        );

    Widget buildLocked() => MaterialApp(
          home: SurveyResultPage(
            result: {
              'passed': false,
              'score': 1,
              'attempts_remaining': 0,
              'locked_until': '2025-12-31T23:59:00Z',
            },
          ),
        );

    testWidgets(
      'Skenario passed: teks "Verifikasi Berhasil!" muncul di layar',
      (tester) async {
        await tester.pumpWidget(buildPassed());
        await tester.pumpAndSettle();

        expect(find.text('Verifikasi Berhasil!'), findsOneWidget);
      },
    );

    testWidgets(
      'Skenario gagal: teks "Verifikasi Gagal" muncul di layar',
      (tester) async {
        await tester.pumpWidget(buildFailed());
        await tester.pumpAndSettle();

        expect(find.text('Verifikasi Gagal'), findsOneWidget);
      },
    );

    testWidgets(
      'Skenario gagal: info sisa percobaan ditampilkan',
      (tester) async {
        await tester.pumpWidget(buildFailed(score: 3, attempts: 1));
        await tester.pumpAndSettle();

        expect(find.textContaining('Sisa percobaan: 1'), findsOneWidget);
      },
    );

    testWidgets(
      'Skenario locked: pesan "kehabisan percobaan" tampil',
      (tester) async {
        await tester.pumpWidget(buildLocked());
        await tester.pumpAndSettle();

        expect(find.textContaining('kehabisan percobaan'), findsOneWidget);
      },
    );

    testWidgets(
      'Halaman passed tidak crash dan tidak memunculkan exception',
      (tester) async {
        await tester.pumpWidget(buildPassed());
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Halaman failed dapat di-scroll ke bawah tanpa error',
      (tester) async {
        await tester.pumpWidget(buildFailed());
        await tester.pumpAndSettle();

        // Coba scroll jika ada konten yang bisa di-scroll
        final scrollFinder = find.byType(SingleChildScrollView);
        if (scrollFinder.evaluate().isNotEmpty) {
          await tester.drag(scrollFinder.first, const Offset(0, -300));
          await tester.pumpAndSettle();
        }

        expect(tester.takeException(), isNull);
      },
    );
  });
}