import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:findkal/settingpage/privacy_notice_page.dart';

void main() {
  group('PrivacyNoticePage - Widget Test', () {
    Widget buildWidget() {
      return const MaterialApp(
        home: PrivacyNoticePage(),
      );
    }

    testWidgets('Menampilkan AppBar dengan judul "Pemberitahuan Privasi"',
        (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Pemberitahuan Privasi'), findsOneWidget);
    });

    testWidgets('AppBar memiliki warna latar belakang teal (0xFF4AA5A6)',
        (tester) async {
      await tester.pumpWidget(buildWidget());

      final AppBar appBar = tester.widget(find.byType(AppBar));
      expect(appBar.backgroundColor, const Color(0xFF4AA5A6));
    });

    testWidgets('Menampilkan tombol kembali di AppBar', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });

    testWidgets('Halaman mengandung SingleChildScrollView untuk konten panjang',
        (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('Menampilkan setidaknya satu section judul privasi',
        (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Verifikasi ada konten teks yang muncul di halaman
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      expect(textWidgets.length, greaterThan(1));
    });

    testWidgets('Scaffold memiliki backgroundColor putih', (tester) async {
      await tester.pumpWidget(buildWidget());

      final Scaffold scaffold = tester.widget(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.white);
    });
  });
}