import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/homepage/home.dart';

// ---------------------------------------------------------------------------
// Widget tests — Home Screen feature
// Covers: class HomePage static UI, initState, _buildHomeContent
// Tester: Arji
// ---------------------------------------------------------------------------

Widget buildTestApp({int initialIndex = 0}) => MaterialApp(
      home: HomePage(initialIndex: initialIndex),
      routes: {
        '/notification': (_) => const Scaffold(body: Text('Notifikasi')),
      },
    );

void main() {
  // ── Static UI ─────────────────────────────────────────────────────────────
  group('HomePage – static UI', () {
    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(HomePage), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(seconds: 20));
    });

    testWidgets('renders BottomNavigationBar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      await tester.pump(const Duration(seconds: 20));
    });

    testWidgets('BottomNavigationBar has Home, Location, and Profile items', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      // Home tab is active (index 0) so its activeIcon (Icons.home) is shown.
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      await tester.pump(const Duration(seconds: 20));
    });

    testWidgets('Home tab is selected by default (index 0)', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.currentIndex, 0);
      await tester.pump(const Duration(seconds: 20));
    });
  });

  // ── initState ─────────────────────────────────────────────────────────────
  group('HomePage – initState', () {
    testWidgets('initialIndex 0 selects Home tab', (tester) async {
      await tester.pumpWidget(buildTestApp(initialIndex: 0));
      await tester.pump();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.currentIndex, 0);
      await tester.pump(const Duration(seconds: 20));
    });

    testWidgets('initialIndex 2 shows Profile tab selected', (tester) async {
      await tester.pumpWidget(buildTestApp(initialIndex: 2));
      await tester.pump();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.currentIndex, 2);
      await tester.pump(const Duration(seconds: 20));
    });

    testWidgets('initState does not crash', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(seconds: 20));
    });

    testWidgets('drains 20s API timeout timer without crashing', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump(const Duration(seconds: 20));

      expect(tester.takeException(), isNull);
    });
  });

  // ── _buildHomeContent ─────────────────────────────────────────────────────
  group('HomePage – _buildHomeContent', () {
    testWidgets('renders search bar with search icon', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.search), findsOneWidget);
      await tester.pump(const Duration(seconds: 20));
    });

    testWidgets('renders "Mau ke mana hari ini?" search hint', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Mau ke mana hari ini?'), findsOneWidget);
      await tester.pump(const Duration(seconds: 20));
    });

    testWidgets('renders notifications icon', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.notifications), findsOneWidget);
      await tester.pump(const Duration(seconds: 20));
    });

    testWidgets('renders greeting text with "Selamat datang"', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.textContaining('Selamat datang'), findsOneWidget);
      await tester.pump(const Duration(seconds: 20));
    });

    testWidgets('renders RefreshIndicator for pull-to-refresh', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(RefreshIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 20));
    });
  });
}
