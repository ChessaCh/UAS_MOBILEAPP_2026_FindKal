import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:findkal/settingpage/privacy_notice_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('PrivacyNoticePage - Integration Test', () {
    Widget buildApp() => const MaterialApp(home: PrivacyNoticePage());

    testWidgets(
      'Halaman terbuka dengan AppBar teal dan judul yang benar',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        expect(find.text('Pemberitahuan Privasi'), findsOneWidget);

        final AppBar appBar = tester.widget(find.byType(AppBar));
        expect(appBar.backgroundColor, const Color(0xFF4AA5A6));
      },
    );

    testWidgets(
      'Konten privasi dapat di-scroll ke bawah',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        final scrollable = find.byType(SingleChildScrollView).first;
        await tester.drag(scrollable, const Offset(0, -300));
        await tester.pumpAndSettle();

        // Tidak ada error setelah scroll
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
                      builder: (_) => const PrivacyNoticePage(),
                    ),
                  ),
                  child: const Text('Open Privacy'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open Privacy'));
        await tester.pumpAndSettle();

        expect(find.byType(PrivacyNoticePage), findsOneWidget);

        await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
        await tester.pumpAndSettle();

        expect(find.byType(PrivacyNoticePage), findsNothing);
        expect(find.text('Open Privacy'), findsOneWidget);
      },
    );

    testWidgets(
      'Halaman menampilkan konten teks (lebih dari 1 widget Text)',
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
        await tester.pumpAndSettle();

        final Scaffold scaffold = tester.widget(find.byType(Scaffold));
        expect(scaffold.backgroundColor, Colors.white);
      },
    );

    testWidgets(
      'Tidak ada error atau exception saat halaman dibuka dan di-scroll penuh',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        // Scroll ke bawah dan kembali ke atas
        final scrollable = find.byType(SingleChildScrollView).first;
        await tester.drag(scrollable, const Offset(0, -500));
        await tester.pumpAndSettle();
        await tester.drag(scrollable, const Offset(0, 500));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );
  });
}