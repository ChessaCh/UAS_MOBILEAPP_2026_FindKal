import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/homepage/home.dart';

// ---------------------------------------------------------------------------
// Widget tests for HomePage
// Tests: static UI, initState, _buildHomeContent, _onItemTapped,
// _handlePendingUpload.
// NOTE: _fetchUnggahans() has a .timeout(20s) that requires draining with
// pump(const Duration(seconds: 20)) in tests that need full settle.
// ---------------------------------------------------------------------------

Widget buildTestApp({
  int initialIndex = 0,
  Future<void> Function()? pendingUpload,
}) => MaterialApp(
      home: HomePage(
        initialIndex: initialIndex,
        pendingUpload: pendingUpload,
      ),
      routes: {
        '/notification': (_) => const Scaffold(body: Text('Notifikasi')),
      },
    );

void main() {
  // ── Static UI ────────────────────────────────────────────────────────────
  group('HomePage – static UI', () {
    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(HomePage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders BottomNavigationBar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('BottomNavigationBar has Home, Location, and Profile items', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('Home tab is selected by default (index 0)', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.currentIndex, 0);
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
    });

    testWidgets('initialIndex 2 shows Profile tab selected', (tester) async {
      await tester.pumpWidget(buildTestApp(initialIndex: 2));
      await tester.pump();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.currentIndex, 2);
    });

    testWidgets('initState does not crash', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(tester.takeException(), isNull);
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
    });

    testWidgets('renders "Mau ke mana hari ini?" search hint', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Mau ke mana hari ini?'), findsOneWidget);
    });

    testWidgets('renders notifications icon', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.notifications), findsOneWidget);
    });

    testWidgets('renders greeting text with "Selamat datang"', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.textContaining('Selamat datang'), findsOneWidget);
    });

    testWidgets('renders RefreshIndicator for pull-to-refresh', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });
  });

  // ── _onItemTapped ─────────────────────────────────────────────────────────
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

  // ── _handlePendingUpload ──────────────────────────────────────────────────
  group('HomePage – _handlePendingUpload', () {
    testWidgets('shows "Mengunggah postingan..." snackbar when provided', (
      tester,
    ) async {
      final completer = Completer<void>();

      await tester.pumpWidget(
        buildTestApp(pendingUpload: () => completer.future),
      );
      await tester.pump(); // first frame — addPostFrameCallback scheduled
      await tester.pump(); // post-frame callback fires → snackbar shown

      expect(find.text('Mengunggah postingan...'), findsOneWidget);

      // Clean up: complete the future and drain all pending timers
      completer.complete();
      await tester.pump();
      await tester.pump(const Duration(seconds: 5)); // success snackbar
      await tester.pump(const Duration(seconds: 20)); // API timeout
    });

    testWidgets('shows CircularProgressIndicator inside loading snackbar', (
      tester,
    ) async {
      final completer = Completer<void>();

      await tester.pumpWidget(
        buildTestApp(pendingUpload: () => completer.future),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);

      completer.complete();
      await tester.pump();
      await tester.pump(const Duration(seconds: 5));
      await tester.pump(const Duration(seconds: 20));
    });

    testWidgets('does not show pending upload snackbar when not provided', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Mengunggah postingan...'), findsNothing);

      await tester.pump(const Duration(seconds: 20));
    });
  });
}
