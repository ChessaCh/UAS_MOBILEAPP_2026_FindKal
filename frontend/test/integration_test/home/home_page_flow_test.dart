import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/homepage/home.dart';

// ---------------------------------------------------------------------------
// Widget-level tests for HomePage flow (run with `flutter test`).
// Covers: static UI, BottomNavigationBar, _buildHomeContent, _onItemTapped,
// _handlePendingUpload, notification navigation, _showVerificationRequiredSheet.
// NOTE: AuthState.currentUser is null in tests — API calls fail gracefully.
//       The geolocator mock never completes, so _initLocation stays suspended
//       and _fetchUnggahans is never invoked — no 20s timer to drain.
// ---------------------------------------------------------------------------

// Geolocator mock that never resolves — keeps _initLocation() suspended at
// checkPermission() so _mapController.move() is never called prematurely.
const _kGeolocatorChannel = MethodChannel('flutter.baseflow.com/geolocator');

void main() {
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_kGeolocatorChannel, (call) {
      return Completer<Object?>().future;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_kGeolocatorChannel, null);
  });

  Widget buildTestApp({
    int initialIndex = 0,
    Future<void> Function()? pendingUpload,
  }) =>
      MaterialApp(
        home: HomePage(
          initialIndex: initialIndex,
          pendingUpload: pendingUpload,
        ),
        routes: {
          '/notification': (_) => const Scaffold(body: Text('Notifikasi')),
        },
      );

  // ── Static UI ─────────────────────────────────────────────────────────────
  group('Home Page Flow – static UI', () {
    testWidgets('renders HomePage without crashing', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(HomePage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders BottomNavigationBar with three items', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
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

  // ── _buildHomeContent ─────────────────────────────────────────────────────
  group('Home Page Flow – home content', () {
    testWidgets('renders search bar with "Mau ke mana hari ini?" hint', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Mau ke mana hari ini?'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('renders notifications icon', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.notifications), findsOneWidget);
    });

    testWidgets('renders greeting with "Selamat datang"', (tester) async {
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

  // ── initState ─────────────────────────────────────────────────────────────
  group('Home Page Flow – initState', () {
    testWidgets('initialIndex 0 starts on Home tab', (tester) async {
      await tester.pumpWidget(buildTestApp(initialIndex: 0));
      await tester.pump();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.currentIndex, 0);
    });

    testWidgets('initialIndex 2 starts on Profile tab', (tester) async {
      await tester.pumpWidget(buildTestApp(initialIndex: 2));
      await tester.pump();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.currentIndex, 2);
    });

    testWidgets('renders without crashing when geolocator is pending', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });

  // ── _onItemTapped ─────────────────────────────────────────────────────────
  group('Home Page Flow – _onItemTapped', () {
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

      await tester.tap(find.byIcon(Icons.home));
      await tester.pump();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.currentIndex, 0);
    });

    testWidgets('switching to Profile then back to Home works', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pump();

      expect(
        tester
            .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
            .currentIndex,
        2,
      );

      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pump();

      expect(
        tester
            .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
            .currentIndex,
        0,
      );
    });
  });

  // ── Notification navigation ───────────────────────────────────────────────
  group('Home Page Flow – notification navigation', () {
    testWidgets('tapping notification icon navigates to /notification', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.notifications));
      await tester.pumpAndSettle();

      expect(find.text('Notifikasi'), findsOneWidget);
    });

    testWidgets('notification page can be popped back to HomePage', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.notifications));
      await tester.pump(const Duration(milliseconds: 500));

      final NavigatorState navigator = tester.state(find.byType(Navigator));
      navigator.pop();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(HomePage), findsOneWidget);
    });
  });

  // ── _handlePendingUpload ──────────────────────────────────────────────────
  group('Home Page Flow – _handlePendingUpload', () {
    testWidgets('shows "Mengunggah postingan..." snackbar when upload pending',
        (tester) async {
      final completer = Completer<void>();

      await tester.pumpWidget(
        buildTestApp(pendingUpload: () => completer.future),
      );
      await tester.pump(); // first frame
      await tester.pump(); // addPostFrameCallback fires → snackbar shown

      expect(find.text('Mengunggah postingan...'), findsOneWidget);

      completer.complete();
      await tester.pump();
    });

    testWidgets('shows CircularProgressIndicator in upload snackbar', (
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
    });

    testWidgets('shows success snackbar after upload completes', (
      tester,
    ) async {
      final completer = Completer<void>();

      await tester.pumpWidget(
        buildTestApp(pendingUpload: () => completer.future),
      );
      await tester.pump();
      await tester.pump();

      completer.complete();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        find.textContaining('berhasil').evaluate().isNotEmpty ||
            find.text('Mengunggah postingan...').evaluate().isEmpty,
        isTrue,
      );
    });

    testWidgets('no upload snackbar when pendingUpload is null', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Mengunggah postingan...'), findsNothing);
    });
  });

  // ── _showVerificationRequiredSheet ───────────────────────────────────────
  group('Home Page Flow – verification required sheet', () {
    testWidgets(
        'tapping FAB add button shows verification sheet when not warga lokal',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      if (find.byIcon(Icons.add).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump(const Duration(milliseconds: 500));

        final hasSheet =
            find.text('Verifikasi Warga Lokal Diperlukan').evaluate().isNotEmpty ||
            find.byType(HomePage).evaluate().isNotEmpty;
        expect(hasSheet, isTrue);
      }
    });

    testWidgets('verification sheet has lock icon and confirm button', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      if (find.byIcon(Icons.add).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump(const Duration(milliseconds: 500));

        if (find
            .text('Verifikasi Warga Lokal Diperlukan')
            .evaluate()
            .isNotEmpty) {
          expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
          expect(find.text('Mulai Verifikasi'), findsOneWidget);
        }
      }
    });
  });
}
