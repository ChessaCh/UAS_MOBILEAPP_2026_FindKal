import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:findkal/settingpage/survey_question_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('SurveyQuestionPage - Integration Test', () {
    Widget buildApp({String region = 'Jakarta'}) => MaterialApp(
          home: SurveyQuestionPage(region: region),
        );

    testWidgets(
      'Halaman terbuka dan menampilkan loading indicator awal',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pump(); // sebelum API selesai

        // Loading indicator harus muncul dulu
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'Region "Bandung" diteruskan dengan benar ke widget',
      (tester) async {
        await tester.pumpWidget(buildApp(region: 'Bandung'));
        await tester.pump();

        final page = tester.widget<SurveyQuestionPage>(
          find.byType(SurveyQuestionPage),
        );
        expect(page.region, 'Bandung');
      },
    );

    testWidgets(
      'Halaman tidak crash saat region berisi string panjang',
      (tester) async {
        await tester.pumpWidget(
          buildApp(region: 'Kabupaten Kepulauan Bangka Belitung'),
        );
        await tester.pump();

        expect(find.byType(Scaffold), findsOneWidget);
      },
    );

    testWidgets(
      'Setelah timeout API: halaman tidak crash (error handled)',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pump(const Duration(seconds: 5));

        // Either shows question content or error state — tidak boleh exception
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Scaffold ditampilkan sebagai root halaman',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pump();

        expect(find.byType(Scaffold), findsOneWidget);
      },
    );

    testWidgets(
      'Navigasi ke SurveyQuestionPage dari parent berjalan dengan benar',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (ctx) => Scaffold(
                body: ElevatedButton(
                  onPressed: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (_) =>
                          const SurveyQuestionPage(region: 'Surabaya'),
                    ),
                  ),
                  child: const Text('Mulai Survey'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Mulai Survey'));
        await tester.pump();

        expect(find.byType(SurveyQuestionPage), findsOneWidget);
      },
    );
  });
}