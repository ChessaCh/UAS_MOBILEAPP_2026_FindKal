import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/homepage/search_overlay_page.dart';

// Fake data: one high-rated place + one low-rated place, so both the
// suggestion and the rating-filter steps have something meaningful to assert.
Future<List<Map<String, dynamic>>> _fakeFetch() async => [
  {
    'id': 1,
    'userName': 'Sabine',
    'usernameHandle': '@vi_enrose9',
    'userAvatar': null,
    'placeName': 'Bear&Butter BSD',
    'rating': 5,
    'address': 'Mall Ararasa BSD, Tangerang Selatan',
    'review': 'Kafenya lucu dan estetik.',
    'budget': 'Rp 50k - Rp 100k',
    'imagePaths': <dynamic>[],
    'latitude': null,
    'longitude': null,
  },
  {
    'id': 2,
    'userName': 'User',
    'usernameHandle': '@user',
    'userAvatar': null,
    'placeName': 'Low Rating Cafe',
    'rating': 2,
    'address': 'Somewhere, Tangerang',
    'review': 'Not great.',
    'budget': 'Rp 1k - Rp 50k',
    'imagePaths': <dynamic>[],
    'latitude': null,
    'longitude': null,
  },
];

void main() {
  Widget buildTestApp() => MaterialApp(
        home: SearchOverlayPage(fetchFn: _fakeFetch),
      );

  group('Complete Search Place Flow', () {
    testWidgets('renders search bar with hint text', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle(); // _fetchPlaces completes

      expect(find.text('Cari tempat atau lokasi...'), findsOneWidget);
    });

    testWidgets('shows places in list after data loads', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Bear&Butter BSD'), findsOneWidget);
      expect(find.text('Low Rating Cafe'), findsOneWidget);
    });

    testWidgets('typing a query shows matching auto-suggestions', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Bear');
      await tester.pump();

      // Suggestion list shows matching place name
      expect(find.text('Bear&Butter BSD'), findsWidgets);
    });

    testWidgets('clearing search restores full place list', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Bear');
      await tester.pump();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(find.text('Bear&Butter BSD'), findsOneWidget);
      expect(find.text('Low Rating Cafe'), findsOneWidget);
    });

    testWidgets('navigates through full search, suggestion, and filtering flow',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle(); // _fetchPlaces completes

      // Search bar hint is visible
      expect(find.text('Cari tempat atau lokasi...'), findsOneWidget);

      // Type a query → auto-suggestions update (_updateSuggestions)
      await tester.enterText(find.byType(TextField), 'Bear');
      await tester.pump();
      expect(find.text('Bear&Butter BSD'), findsWidgets);

      // Clear text so filter acts on the full list
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      // Open filter modal (_showFilterModal)
      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();

      // Select 4.0+ minimum rating
      await tester.tap(find.text('4.0+'));
      await tester.pump();

      // Apply filter (_applyFilter) and dismiss modal
      await tester.tap(find.text('Terapkan'));
      await tester.pumpAndSettle();

      // Bear&Butter BSD (rating 5.0 ≥ 4.0) still visible
      expect(find.text('Bear&Butter BSD'), findsOneWidget);
      // Low Rating Cafe (rating 2.0 < 4.0) filtered out
      expect(find.text('Low Rating Cafe'), findsNothing);
      // Filter modal is closed
      expect(find.text('Filter Pencarian'), findsNothing);
    });
  });
}
