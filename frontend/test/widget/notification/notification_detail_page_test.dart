import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/homepage/notification_detail_page.dart';
import 'package:findkal/models/unggahan.dart';

// ---------------------------------------------------------------------------
// Widget tests for NotificationDetailPage
// Tests: default title/subtitle, dummy locations, real places, back arrow,
// Navigator.push behaviour.
// NOTE: StatelessWidget — no async operations.
// ---------------------------------------------------------------------------

Widget buildTestApp({
  String? title,
  String? subtitle,
  List<Unggahan>? places,
}) => MaterialApp(
      home: NotificationDetailPage(
        title: title,
        subtitle: subtitle,
        places: places,
      ),
    );

Unggahan _fakeUnggahan({
  String placeName = 'Pantai Anyer',
  String address = 'Cilegon, Banten',
  String review = 'Pantai yang indah dan bersih',
  String budget = 'Rp 20.000',
}) => Unggahan(
      id: 1,
      placeName: placeName,
      address: address,
      review: review,
      budget: budget,
      imagePaths: [],
      lat: null,
      lng: null,
      rating: 4,
      userName: 'User',
      usernameHandle: '@user',
    );

void main() {
  // ── Static UI – default (no title/subtitle/places) ───────────────────────
  group('NotificationDetailPage – default static UI', () {
    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(NotificationDetailPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders default title "Tempat Ini Favoritnya Warlok!"', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Tempat Ini Favoritnya Warlok!'), findsOneWidget);
    });

    testWidgets('renders back arrow icon', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });
  });

  // ── Dummy locations (no places provided) ─────────────────────────────────
  group('NotificationDetailPage – dummy locations', () {
    testWidgets('shows "The Breeze, BSD" dummy location', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('The Breeze'), findsOneWidget);
    });

    testWidgets('shows "Scientia Square Park" dummy location', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Scientia Square Park'), findsOneWidget);
    });

    testWidgets('shows "The Barn, BSD" dummy location', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('The Barn'), findsOneWidget);
    });

    testWidgets('shows numbered list "1." prefix', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('1.'), findsOneWidget);
    });
  });

  // ── Custom title/subtitle ─────────────────────────────────────────────────
  group('NotificationDetailPage – custom title', () {
    testWidgets('renders provided title instead of default', (tester) async {
      await tester.pumpWidget(
        buildTestApp(title: 'Tempat Baru Ditemukan!'),
      );
      await tester.pump();

      expect(find.text('Tempat Baru Ditemukan!'), findsOneWidget);
      expect(find.text('Tempat Ini Favoritnya Warlok!'), findsNothing);
    });

    testWidgets('renders provided subtitle text', (tester) async {
      await tester.pumpWidget(
        buildTestApp(subtitle: 'Berikut rekomendasi tempat terbaru:'),
      );
      await tester.pump();

      expect(
        find.text('Berikut rekomendasi tempat terbaru:'),
        findsOneWidget,
      );
    });
  });

  // ── Real places list ──────────────────────────────────────────────────────
  group('NotificationDetailPage – real places', () {
    testWidgets('renders place name from provided places', (tester) async {
      final places = [_fakeUnggahan(placeName: 'Kawah Ratu')];
      await tester.pumpWidget(buildTestApp(places: places));
      await tester.pumpAndSettle();

      expect(find.textContaining('Kawah Ratu'), findsOneWidget);
    });

    testWidgets('renders place address from provided places', (tester) async {
      final places = [
        _fakeUnggahan(
          placeName: 'Kawah Ratu',
          address: 'Gunung Salak, Bogor',
        ),
      ];
      await tester.pumpWidget(buildTestApp(places: places));
      await tester.pumpAndSettle();

      expect(find.textContaining('Gunung Salak'), findsOneWidget);
    });

    testWidgets('does not show dummy locations when real places provided', (
      tester,
    ) async {
      final places = [_fakeUnggahan(placeName: 'Kawah Ratu')];
      await tester.pumpWidget(buildTestApp(places: places));
      await tester.pumpAndSettle();

      expect(find.textContaining('The Breeze'), findsNothing);
    });

    testWidgets('renders multiple places correctly', (tester) async {
      final places = [
        _fakeUnggahan(placeName: 'Pantai Anyer'),
        _fakeUnggahan(placeName: 'Pantai Carita'),
      ];
      await tester.pumpWidget(buildTestApp(places: places));
      await tester.pumpAndSettle();

      expect(find.textContaining('Pantai Anyer'), findsOneWidget);
      expect(find.textContaining('Pantai Carita'), findsOneWidget);
    });
  });

  // ── Navigator.push ────────────────────────────────────────────────────────
  group('NotificationDetailPage – Navigator.push', () {
    testWidgets('page can be pushed via Navigator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => const NotificationDetailPage(
                    title: 'Test Detail',
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

      expect(find.text('Test Detail'), findsOneWidget);
    });

    testWidgets('tapping back arrow pops the page', (tester) async {
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
}
