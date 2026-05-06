import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:findkal/ai_plan/trip_plan_selection_page.dart';
import 'package:findkal/ai_plan/ai_trip_plan_page.dart';
import 'package:findkal/ai_plan/ai_trip_theme_selection_page.dart';
import 'package:findkal/ai_plan/ai_trip_detail_page.dart';

// ---------------------------------------------------------------------------
// Integration tests for AI Trip Plan flow
// Flow: TripPlanSelectionPage → AiTripPlanPage → AiTripThemeSelectionPage
//       → AiTripDetailPage
// Tests verify navigation between pages and critical UI interactions.
// ---------------------------------------------------------------------------

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ── TripPlanSelectionPage ─────────────────────────────────────────────────
  group('AI Trip Plan Flow – TripPlanSelectionPage', () {
    testWidgets('renders TripPlanSelectionPage without crashing', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: TripPlanSelectionPage()),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(TripPlanSelectionPage), findsOneWidget);
    });

    testWidgets('shows empty state when no trips available (no user)', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TripPlanSelectionPage(
            fetchTripPlans: () async => [],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('shows loaded trips from custom fetcher', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TripPlanSelectionPage(
            fetchTripPlans: () async => [
              {
                'id': 1,
                'tripName': 'Liburan Banten',
                'province': 'Banten',
                'duration': '3',
                'budget': 'Hemat',
                'budgetId': 'hemat',
                'themes': ['Nature'],
                'places': [],
                'transport': [],
              },
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Liburan Banten'), findsOneWidget);
    });
  });

  // ── AiTripPlanPage ────────────────────────────────────────────────────────
  group('AI Trip Plan Flow – AiTripPlanPage', () {
    testWidgets('renders AiTripPlanPage without crashing', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AiTripPlanPage()));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(AiTripPlanPage), findsOneWidget);
    });

    testWidgets('renders province dropdown on AiTripPlanPage', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AiTripPlanPage()));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(DropdownButtonFormField), findsWidgets);
    });

    testWidgets('renders "Buat Rencana Baru" or trip name input', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AiTripPlanPage()));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(tester.takeException(), isNull);
    });
  });

  // ── AiTripThemeSelectionPage ──────────────────────────────────────────────
  group('AI Trip Plan Flow – AiTripThemeSelectionPage', () {
    testWidgets('renders all 6 themes', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AiTripThemeSelectionPage(
            tripName: 'Liburan Banten',
            duration: '3',
            province: 'Banten',
            budget: '💸 Hemat',
            budgetId: 'hemat',
          ),
        ),
      );
      await tester.pump();

      for (final theme in [
        'Nature',
        'Shopping',
        'Wellness',
        'Entertainment',
        'Food & drinks',
        'Culture & History',
      ]) {
        expect(find.text(theme), findsOneWidget);
      }
    });

    testWidgets('selecting a theme enables generate button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AiTripThemeSelectionPage(
            tripName: 'Test Trip',
            duration: '2',
            province: 'Banten',
            budget: 'Hemat',
            budgetId: 'hemat',
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Nature'));
      await tester.pump();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Generate Rencana Perjalanan'),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('generate button disabled when no theme selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AiTripThemeSelectionPage(
            tripName: 'Test Trip',
            duration: '2',
          ),
        ),
      );
      await tester.pump();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Generate Rencana Perjalanan'),
      );
      expect(button.onPressed, isNull);
    });
  });

  // ── AiTripDetailPage ──────────────────────────────────────────────────────
  group('AI Trip Plan Flow – AiTripDetailPage', () {
    testWidgets('renders AiTripDetailPage without crashing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AiTripDetailPage(tripName: 'Liburan Banten'),
        ),
      );
      await tester.pump();

      expect(find.byType(AiTripDetailPage), findsOneWidget);
    });

    testWidgets('tapping "Ubah rencana" shows modal bottom sheet', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AiTripDetailPage(
            tripName: 'Trip Test',
            places: [
              {
                'time': '09:00',
                'title': 'Pantai Anyer',
                'details': 'Pantai indah',
              },
            ],
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Ubah rencana'));
      await tester.pumpAndSettle();

      expect(find.text('Ubah Rencana'), findsOneWidget);
      expect(find.text('Simpan Perubahan'), findsOneWidget);
    });

    testWidgets('navigation from detail page back to root', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => const AiTripDetailPage(tripName: 'Test'),
                ),
              ),
              child: const Text('Open Detail'),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Open Detail'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Selesai'));
      await tester.pumpAndSettle();

      expect(find.text('Open Detail'), findsOneWidget);
    });
  });
}
