import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:findkal/settingpage/terms_conditions_page.dart';

void main() {
  group('TermsConditionsPage - Widget Test', () {
    Widget buildWidget() {
      return const MaterialApp(
        home: TermsConditionsPage(),
      );
    }

    testWidgets('Menampilkan AppBar dengan judul "Syarat & Ketentuan"',
        (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Syarat & Ketentuan'), findsOneWidget);
    });

    testWidgets('AppBar memiliki warna latar belakang teal (0xFF4AA5A6)',
        (tester) async {
      await tester.pumpWidget(buildWidget());

      final AppBar appBar = tester.widget(find.byType(AppBar));
      expect(appBar.backgroundColor, const Color(0xFF4AA5A6));
    });

    testWidgets('Menampilkan tombol back (icon arrow_back_ios_new_rounded)',
        (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });

    testWidgets('Halaman dapat di-scroll (menggunakan SingleChildScrollView)',
        (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('Scaffold memiliki backgroundColor putih', (tester) async {
      await tester.pumpWidget(buildWidget());

      final Scaffold scaffold = tester.widget(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.white);
    });

    testWidgets('Halaman menampilkan lebih dari satu widget teks (ada konten)',
        (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      final texts = tester.widgetList<Text>(find.byType(Text));
      expect(texts.length, greaterThan(1));
    });
  });
}