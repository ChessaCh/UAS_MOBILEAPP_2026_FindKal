import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:findkal/settingpage/terms_conditions_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('TermsConditionsPage - Integration Test', () {
    Widget buildApp() => const MaterialApp(home: TermsConditionsPage());

    testWidgets(
      'Halaman terbuka dengan AppBar teal dan judul "Syarat & Ketentuan"',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        expect(find.text('Syarat & Ketentuan'), findsOneWidget);

        final AppBar appBar = tester.widget(find.byType(AppBar));
        expect(appBar.backgroundColor, const Color(0xFF4AA5A6));
      },
    );

    testWidgets(
      'Konten syarat dapat di-scroll ke bawah tanpa error',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        final scrollable = find.byType(SingleChildScrollView).first;
        await tester.drag(scrollable, const Offset(0, -400));
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      },
    );

    testWidgets(
      'Tap tombol back → kembali ke halaman sebelumnya',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (ctx) => Scaffold(
                body: ElevatedButton(
                  onPressed: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (_) => const TermsConditionsPage(),
                    ),
                  ),
                  child: const Text('Open Terms'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open Terms'));
        await tester.pumpAndSettle();

        expect(find.byType(TermsConditionsPage), findsOneWidget);

        await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
        await tester.pumpAndSettle();

        expect(find.byType(TermsConditionsPage), findsNothing);
        expect(find.text('Open Terms'), findsOneWidget);
      },
    );

    testWidgets(
      'Halaman menampilkan lebih dari 1 widget teks (ada konten)',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        final texts = tester.widgetList<Text>(find.byType(Text)).toList();
        expect(texts.length, greaterThan(1));
      },
    );

    testWidgets(
      'Scaffold background berwarna putih',
      (tester) async {
        await tester.pumpWidget(buildApp());

        final Scaffold scaffold = tester.widget(find.byType(Scaffold));
        expect(scaffold.backgroundColor, Colors.white);
      },
    );

    testWidgets(
      'Tidak ada exception saat scroll penuh bolak-balik',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        final scrollable = find.byType(SingleChildScrollView).first;
        await tester.drag(scrollable, const Offset(0, -600));
        await tester.pumpAndSettle();
        await tester.drag(scrollable, const Offset(0, 600));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );
  });
}