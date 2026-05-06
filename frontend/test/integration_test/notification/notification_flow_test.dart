import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:findkal/homepage/notification.dart';
import 'package:findkal/homepage/notification_detail_page.dart';
import 'package:findkal/models/unggahan.dart';

// ---------------------------------------------------------------------------
// Integration tests for Notification flow
// Tests: NotificationPage static UI, empty state (no user in test env),
// loading state, back navigation, NotificationDetailPage push/pop,
// detail page renders title/places, back arrow from detail page.
// NOTE: AuthState.currentUser is null in tests — _loadData() returns
// immediately with _loading = false and empty lists.
// ---------------------------------------------------------------------------

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Widget buildNotificationApp() =>
      const MaterialApp(home: NotificationPage());

  Unggahan fakeUnggahan({
    String placeName = 'Pantai Anyer',
    String address = 'Cilegon, Banten',
  }) =>
      Unggahan(
        id: 1,
        placeName: placeName,
        address: address,
        review: 'Pantai yang indah',
        budget: 'Rp 20.000',
        imagePaths: [],
        lat: null,
        lng: null,
        rating: 4,
        userName: 'User',
        usernameHandle: '@user',
      );

  // ── NotificationPage – static UI ─────────────────────────────────────────
  group('Notification Flow – static UI', () {
    testWidgets('renders NotificationPage without crashing', (tester) async {
      await tester.pumpWidget(buildNotificationApp());
      await tester.pumpAndSettle();

      expect(find.byType(NotificationPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders "Notifikasi" title in AppBar', (tester) async {
      await tester.pumpWidget(buildNotificationApp());
      await tester.pumpAndSettle();

      expect(find.text('Notifikasi'), findsOneWidget);
    });

    testWidgets('renders back arrow icon', (tester) async {
      await tester.pumpWidget(buildNotificationApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });
  });

  // ── NotificationPage – empty state (no user) ─────────────────────────────
  group('Notification Flow – empty state', () {
    testWidgets('shows "Belum ada notifikasi." when no user logged in', (
      tester,
    ) async {
      await tester.pumpWidget(buildNotificationApp());
      await tester.pumpAndSettle();

      expect(find.text('Belum ada notifikasi.'), findsOneWidget);
    });

    testWidgets('loading indicator is gone after load completes', (
      tester,
    ) async {
      await tester.pumpWidget(buildNotificationApp());
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  // ── NotificationPage – back navigation ───────────────────────────────────
  group('Notification Flow – back navigation', () {
    testWidgets('NotificationPage can be pushed via Navigator', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => Navigator.push(
                ctx,
                MaterialPageRoute(builder: (_) => const NotificationPage()),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Notifikasi'), findsOneWidget);
    });

    testWidgets('tapping back arrow pops NotificationPage', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => Navigator.push(
                ctx,
                MaterialPageRoute(builder: (_) => const NotificationPage()),
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
  });

  // ── NotificationDetailPage – push from notification tap ──────────────────
  group('Notification Flow – detail page navigation', () {
    testWidgets('NotificationDetailPage can be pushed via Navigator', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => const NotificationDetailPage(
                    title: 'Tempat Baru Ditemukan!',
                  ),
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

      expect(find.text('Tempat Baru Ditemukan!'), findsOneWidget);
    });

    testWidgets('tapping back arrow on detail page pops back', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => const NotificationDetailPage(),
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

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle();

      expect(find.text('Open Detail'), findsOneWidget);
    });
  });

  // ── NotificationDetailPage – renders content ─────────────────────────────
  group('Notification Flow – detail page content', () {
    testWidgets('renders default title when none provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: NotificationDetailPage()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tempat Ini Favoritnya Warlok!'), findsOneWidget);
    });

    testWidgets('renders custom title and subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NotificationDetailPage(
            title: 'Tempat Baru Ditemukan!',
            subtitle: 'Berikut tempat-tempat baru yang baru saja dibagikan:',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tempat Baru Ditemukan!'), findsOneWidget);
      expect(
        find.text('Berikut tempat-tempat baru yang baru saja dibagikan:'),
        findsOneWidget,
      );
    });

    testWidgets('renders dummy locations when no places provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: NotificationDetailPage()),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('The Breeze'), findsOneWidget);
      expect(find.textContaining('Scientia Square Park'), findsOneWidget);
      expect(find.textContaining('The Barn'), findsOneWidget);
    });

    testWidgets('renders place name when real places provided', (
      tester,
    ) async {
      final places = [fakeUnggahan(placeName: 'Kawah Ratu')];
      await tester.pumpWidget(
        MaterialApp(
          home: NotificationDetailPage(places: places),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Kawah Ratu'), findsOneWidget);
    });

    testWidgets('renders place address inside RichText when places provided', (
      tester,
    ) async {
      final places = [
        fakeUnggahan(placeName: 'Kawah Ratu', address: 'Gunung Salak, Bogor'),
      ];
      await tester.pumpWidget(
        MaterialApp(
          home: NotificationDetailPage(places: places),
        ),
      );
      await tester.pumpAndSettle();

      // Address is rendered inside RichText/TextSpan, not a plain Text widget.
      expect(
        find.byWidgetPredicate((widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('Gunung Salak')),
        findsOneWidget,
      );
    });

    testWidgets('does not show dummy locations when real places provided', (
      tester,
    ) async {
      final places = [fakeUnggahan(placeName: 'Kawah Ratu')];
      await tester.pumpWidget(
        MaterialApp(
          home: NotificationDetailPage(places: places),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('The Breeze'), findsNothing);
    });

    testWidgets('renders multiple places correctly', (tester) async {
      final places = [
        fakeUnggahan(placeName: 'Pantai Anyer'),
        fakeUnggahan(placeName: 'Pantai Carita'),
      ];
      await tester.pumpWidget(
        MaterialApp(
          home: NotificationDetailPage(places: places),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Pantai Anyer'), findsOneWidget);
      expect(find.textContaining('Pantai Carita'), findsOneWidget);
    });
  });
}
