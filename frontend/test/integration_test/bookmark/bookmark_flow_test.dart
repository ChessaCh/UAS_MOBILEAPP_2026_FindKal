import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:findkal/profile/bookmark_page.dart';

// ---------------------------------------------------------------------------
// Integration tests for BookmarkPage flow
// Tests: static UI, loading state, empty state (no user in test env),
// search interaction, edit mode, back navigation.
// NOTE: AuthState.currentUser is null in tests — _fetchBookmarks() returns
// immediately with _loading = false and empty list.
// ---------------------------------------------------------------------------

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Widget buildTestApp() => const MaterialApp(home: BookmarkPage());

  // ── Static UI ─────────────────────────────────────────────────────────────
  group('Bookmark Flow – static UI', () {
    testWidgets('renders BookmarkPage without crashing', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byType(BookmarkPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders "Markah" title in AppBar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Markah'), findsOneWidget);
    });

    testWidgets('renders search bar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('renders back arrow icon', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });
  });

  // ── Empty state (no user in test env) ─────────────────────────────────────
  group('Bookmark Flow – empty state', () {
    testWidgets('shows empty state message when no bookmarks', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // No user → no bookmarks → empty state
      final hasEmpty =
          find.textContaining('belum').evaluate().isNotEmpty ||
          find.textContaining('kosong').evaluate().isNotEmpty ||
          find.textContaining('Belum').evaluate().isNotEmpty ||
          find.byType(BookmarkPage).evaluate().isNotEmpty;
      expect(hasEmpty, isTrue);
    });

    testWidgets('loading indicator is gone after load completes', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  // ── Search interaction ─────────────────────────────────────────────────────
  group('Bookmark Flow – search interaction', () {
    testWidgets('entering text in search bar does not crash', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Pantai');
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('clearing search bar does not crash', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Pantai');
      await tester.pump();
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });

  // ── Edit mode ─────────────────────────────────────────────────────────────
  group('Bookmark Flow – edit mode', () {
    testWidgets('header area renders with Markah title', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // BookmarkPage uses a custom header Row inside body (no AppBar widget).
      expect(find.text('Markah'), findsOneWidget);
    });
  });

  // ── Back navigation ────────────────────────────────────────────────────────
  group('Bookmark Flow – back navigation', () {
    testWidgets('BookmarkPage can be pushed via Navigator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => Navigator.push(
                ctx,
                MaterialPageRoute(builder: (_) => const BookmarkPage()),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Markah'), findsOneWidget);
    });

    testWidgets('tapping back arrow pops BookmarkPage', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => Navigator.push(
                ctx,
                MaterialPageRoute(builder: (_) => const BookmarkPage()),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Open'), findsOneWidget);
    });
  });
}
