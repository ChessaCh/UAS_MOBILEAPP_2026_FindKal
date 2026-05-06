import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/homepage/home.dart';

// ---------------------------------------------------------------------------
// Widget tests — Map (bisa ditekan) feature
// Covers: _onItemTapped tab switching behaviour
// Tester: Arji
// ---------------------------------------------------------------------------

Widget buildTestApp() => MaterialApp(
      home: const HomePage(),
      routes: {
        '/notification': (_) => const Scaffold(body: Text('Notifikasi')),
      },
    );

void main() {
  group('HomePage – _onItemTapped', () {
    testWidgets('tapping Profile tab (index 2) updates selectedIndex', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pump();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.currentIndex, 2);
    });

    testWidgets('tapping Home tab keeps index at 0', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pump();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.currentIndex, 0);
    });
  });
}
