import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:findkal/settingpage/survey_result_page.dart';

void main() {
  group('SurveyResultPage - Widget Test', () {
    Widget buildPassedWidget() {
      return MaterialApp(
        home: SurveyResultPage(
          result: {
            'passed': true,
            'score': 5,
            'attempts_remaining': 0,
            'locked_until': null,
          },
        ),
      );
    }

    Widget buildFailedWidget({int score = 2, int attemptsRemaining = 2}) {
      return MaterialApp(
        home: SurveyResultPage(
          result: {
            'passed': false,
            'score': score,
            'attempts_remaining': attemptsRemaining,
            'locked_until': null,
          },
        ),
      );
    }

    Widget buildLockedWidget() {
      return MaterialApp(
        home: SurveyResultPage(
          result: {
            'passed': false,
            'score': 1,
            'attempts_remaining': 0,
            'locked_until': '2025-12-31T23:59:00Z',
          },
        ),
      );
    }

    testWidgets('Menampilkan teks "Verifikasi Berhasil!" saat passed=true',
        (tester) async {
      await tester.pumpWidget(buildPassedWidget());
      await tester.pumpAndSettle();

      expect(find.text('Verifikasi Berhasil!'), findsOneWidget);
    });

    testWidgets('Menampilkan teks "Verifikasi Gagal" saat passed=false',
        (tester) async {
      await tester.pumpWidget(buildFailedWidget());
      await tester.pumpAndSettle();

      expect(find.text('Verifikasi Gagal'), findsOneWidget);
    });

    testWidgets('Menampilkan sisa percobaan di pesan gagal', (tester) async {
      await tester.pumpWidget(buildFailedWidget(score: 2, attemptsRemaining: 3));
      await tester.pumpAndSettle();

      // Pesan mencakup info sisa percobaan
      expect(find.textContaining('Sisa percobaan: 3'), findsOneWidget);
    });

    testWidgets(
        'Menampilkan pesan locked_until ketika tidak ada percobaan tersisa',
        (tester) async {
      await tester.pumpWidget(buildLockedWidget());
      await tester.pumpAndSettle();

      // Pesan harus menyebutkan "kehabisan percobaan"
      expect(find.textContaining('kehabisan percobaan'), findsOneWidget);
    });

    testWidgets('Menampilkan Scaffold sebagai root widget', (tester) async {
      await tester.pumpWidget(buildPassedWidget());

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Menampilkan header berwarna teal di atas halaman',
        (tester) async {
      await tester.pumpWidget(buildPassedWidget());
      await tester.pumpAndSettle();

      // Terdapat Container dengan warna teal (0xFF4AA5A6)
      final containers = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) => c.color == const Color(0xFF4AA5A6))
          .toList();
      expect(containers.isNotEmpty, isTrue);
    });
  });
}