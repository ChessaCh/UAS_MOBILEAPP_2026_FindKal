import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/ai_plan/ai_trip_theme_selection_page.dart';

// ---------------------------------------------------------------------------
// Widget tests for AiTripThemeSelectionPage
// Tests: theme grid rendering, _toggleTheme selection state,
// generate button enabled/disabled, loading overlay, back navigation.
// ---------------------------------------------------------------------------

Widget buildTestApp({
  String tripName = 'Liburan Banten',
  String duration = '3',
}) => MaterialApp(
      home: AiTripThemeSelectionPage(
        tripName: tripName,
        duration: duration,
        province: 'Banten',
        budget: '💸 Hemat — < Rp100.000',
        budgetId: 'hemat',
      ),
    );

void main() {
  // ── Static UI ───────────────────────────────────────────────────────────────
  group('AiTripThemeSelectionPage – static UI', () {
    testWidgets('renders page title "Pilih Tema Perjalanan"', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Pilih Tema Perjalanan'), findsOneWidget);
    });

    testWidgets('renders subtitle/instruction text', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.textContaining('Pilih minimal 1 tema'), findsOneWidget);
    });

    testWidgets('back arrow is present in AppBar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
    });

    testWidgets('renders "Generate Rencana Perjalanan" button', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Generate Rencana Perjalanan'), findsOneWidget);
    });

    testWidgets('renders all 6 theme chips', (tester) async {
      await tester.pumpWidget(buildTestApp());
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
  });

  // ── _onThemeSelected – generate button state ────────────────────────────────
  group('AiTripThemeSelectionPage – generate button', () {
    testWidgets('generate button is disabled when no theme selected', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Generate Rencana Perjalanan'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('generate button is enabled after selecting a theme', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.text('Nature'));
      await tester.pump();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Generate Rencana Perjalanan'),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('generate button is re-disabled after deselecting all themes', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.text('Nature'));
      await tester.pump();
      await tester.tap(find.text('Nature')); // deselect
      await tester.pump();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Generate Rencana Perjalanan'),
      );
      expect(button.onPressed, isNull);
    });
  });

  // ── _toggleTheme – selection state ─────────────────────────────────────────
  group('AiTripThemeSelectionPage – _toggleTheme', () {
    testWidgets('tapping a theme chip does not throw', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.text('Nature'));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('check_circle icon appears after theme is selected', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.check_circle), findsNothing);

      await tester.tap(find.text('Shopping'));
      await tester.pump();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('check_circle disappears when theme is deselected', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.text('Wellness'));
      await tester.pump();
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      await tester.tap(find.text('Wellness'));
      await tester.pump();
      expect(find.byIcon(Icons.check_circle), findsNothing);
    });

    testWidgets('multiple themes can be selected simultaneously', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.text('Nature'));
      await tester.pump();
      await tester.tap(find.text('Food & drinks'));
      await tester.pump();

      expect(find.byIcon(Icons.check_circle), findsNWidgets(2));
    });
  });

  // ── Back navigation ─────────────────────────────────────────────────────────
  group('AiTripThemeSelectionPage – back navigation', () {
    testWidgets('tapping back arrow pops the page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => const AiTripThemeSelectionPage(
                    tripName: 'Test Trip',
                    duration: '2',
                  ),
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      expect(find.text('Open'), findsOneWidget);
    });
  });

  // ── Generating state ────────────────────────────────────────────────────────
  group('AiTripThemeSelectionPage – generating state', () {
    testWidgets('tapping generate with a theme selected does not throw', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.text('Nature'));
      await tester.pump();

      await tester.tap(
        find.text('Generate Rencana Perjalanan'),
      );
      await tester.pump();

      // Either shows LinearProgressIndicator (generating state) or stays on page
      expect(tester.takeException(), isNull);
    });
  });
}
