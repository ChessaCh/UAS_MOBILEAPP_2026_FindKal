import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/homepage/notification.dart';

// ---------------------------------------------------------------------------
// Widget tests for NotificationPage
// Tests: static UI (title, back arrow), loading state, empty state,
// Navigator.push behaviour.
// NOTE: AuthState.currentUser is null in tests — _loadData() returns early
// synchronously, _loading = false, "Belum ada notifikasi." is shown.
// ---------------------------------------------------------------------------

Widget buildTestApp() => const MaterialApp(home: NotificationPage());

void main() {
  // ── Static UI ────────────────────────────────────────────────────────────
  group('NotificationPage – static UI', () {
    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(NotificationPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders "Notifikasi" title in AppBar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Notifikasi'), findsOneWidget);
    });

    testWidgets('renders back arrow icon in AppBar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });
  });

  // ── Empty state (no user in test env) ────────────────────────────────────
  group('NotificationPage – empty state', () {
    testWidgets('shows "Belum ada notifikasi." when no user logged in', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Belum ada notifikasi.'), findsOneWidget);
    });

    testWidgets('does not show CircularProgressIndicator after load', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('renders ListView when loading is complete', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
    });
  });

  // ── Navigator.push / back navigation ─────────────────────────────────────
  group('NotificationPage – back navigation', () {
    testWidgets('tapping back arrow pops the page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => const NotificationPage(),
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

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle();

      expect(find.text('Open'), findsOneWidget);
    });

    testWidgets('NotificationPage can be pushed via Navigator', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => const NotificationPage(),
                ),
              ),
              child: const Text('Go'),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      expect(find.text('Notifikasi'), findsOneWidget);
    });
  });
}
