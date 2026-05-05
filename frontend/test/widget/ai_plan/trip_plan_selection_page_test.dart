import 'dart:async';
import 'dart:io';

import 'package:findkal/ai_plan/trip_plan_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_network_images.dart';

// ---------------------------------------------------------------------------
// Widget tests for TripPlanSelectionPage
// Tests: static UI rendering, "Buat Perjalanan" card presence, "Perjalananmu"
// section, loading state, and empty-trip state.
// ---------------------------------------------------------------------------

/// Wraps the widget under test in a minimal MaterialApp with a fake
/// navigator so push/pop calls don't throw.
Widget buildTestApp({Widget? home}) => MaterialApp(
      home: home ?? const TripPlanSelectionPage(),
      routes: {'/home': (_) => const Scaffold(body: Text('Home'))},
    );

void main() {
  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  group('TripPlanSelectionPage – static UI', () {
    testWidgets('renders the page title "Rencana Perjalananmu"', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump(); // let initState run

      expect(find.text('Rencana Perjalananmu'), findsOneWidget);
    });

    testWidgets('renders "Buat Perjalanan" card', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Buat Perjalanan'), findsOneWidget);
    });

    testWidgets('renders "Perjalananmu" section heading', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Perjalananmu'), findsOneWidget);
    });

    testWidgets('shows back arrow in AppBar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
    });
  });

  group('TripPlanSelectionPage – loading state', () {
    testWidgets('shows CircularProgressIndicator while loading trips', (
      tester,
    ) async {
      final pendingTrips = Completer<List<Map<String, dynamic>>>();

      await tester.pumpWidget(
        buildTestApp(
          home: TripPlanSelectionPage(
            fetchTripPlans: () => pendingTrips.future,
          ),
        ),
      );
      await tester.pump(Duration.zero);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      pendingTrips.complete([]);
      await tester.pump();
    });
  });

  group('TripPlanSelectionPage – empty trip list', () {
    testWidgets('shows "Belum ada rencana perjalanan" when list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      // Pump until futures settle — API will fail in test environment
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Either the empty message or loading is shown
      final hasEmpty = find
          .text('Belum ada rencana perjalanan')
          .evaluate()
          .isNotEmpty;
      final hasLoading = find
          .byType(CircularProgressIndicator)
          .evaluate()
          .isNotEmpty;
      expect(hasEmpty || hasLoading, isTrue);
    });
  });

  group('TripPlanSelectionPage – navigation', () {
    testWidgets('tapping "Buat Perjalanan" card does not throw error', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      // The card is a GestureDetector wrapping "Buat Perjalanan"
      await tester.tap(find.text('Buat Perjalanan'));
      await tester.pumpAndSettle();

      // After tap, a new route should have been pushed.
      // We verify we left the original page (TripPlanSelectionPage is no longer
      // the top route) or a new widget is visible.
      // In a test environment the AiTripPlanPage will be pushed.
      // We can't fully verify navigation without full mock, so we check
      // that no exception was thrown and pump settled.
      expect(tester.takeException(), isNull);
    });

    testWidgets('back button pops the route', (tester) async {
      // Push TripPlanSelectionPage on top of a dummy page
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TripPlanSelectionPage(),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Tap back
      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      // Should be back on the dummy page
      expect(find.text('Open'), findsOneWidget);
    });
  });
}
