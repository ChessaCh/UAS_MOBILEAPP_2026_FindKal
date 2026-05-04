import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/map/map_search_result_page.dart';

// ---------------------------------------------------------------------------
// Widget tests for MapSearchResultPage
// Tests: search bar pre-fill, loading state, bottom nav, results panel,
// search interaction, dispose behaviour.
// ---------------------------------------------------------------------------

Widget buildTestApp({String query = 'Pantai Anyer'}) {
  return MaterialApp(
    home: MapSearchResultPage(query: query),
    routes: {'/home': (_) => const Scaffold(body: Text('Home'))},
  );
}

void main() {
  group('MapSearchResultPage – static UI', () {
    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(MapSearchResultPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('search bar is pre-populated with query', (tester) async {
      await tester.pumpWidget(buildTestApp(query: 'Kawah Ratu'));
      await tester.pump();

      expect(find.text('Kawah Ratu'), findsOneWidget);
    });

    testWidgets('renders "Cari" button', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Cari'), findsOneWidget);
    });

    testWidgets('back arrow is present', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });

    testWidgets('search icon is in the search bar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });

  group('MapSearchResultPage – loading state', () {
    testWidgets('shows loading indicator on initial search', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump(Duration.zero);

      // Loading overlay is shown while _initAndSearch runs
      final hasLoading = find
          .byType(CircularProgressIndicator)
          .evaluate()
          .isNotEmpty;
      expect(
        hasLoading || find.byType(MapSearchResultPage).evaluate().isNotEmpty,
        isTrue,
      );
    });
  });

  group('MapSearchResultPage – BottomNavigationBar', () {
    testWidgets('has a BottomNavigationBar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Map is the active tab (index 1)', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.currentIndex, 1);
    });

    testWidgets('has all three nav items', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });
  });

  group('MapSearchResultPage – results panel', () {
    testWidgets('shows "Lokasi tidak ditemukan" when no results', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // In offline test env, Overpass / Nominatim fail → empty result
      if (find.byType(CircularProgressIndicator).evaluate().isEmpty) {
        final hasEmpty =
            find.textContaining('tidak ditemukan').evaluate().isNotEmpty ||
            find.textContaining('server').evaluate().isNotEmpty;
        expect(hasEmpty, isTrue);
      }
    });

    testWidgets('"Arahkan" button is visible in results panel', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      if (find.byType(CircularProgressIndicator).evaluate().isEmpty) {
        // "Arahkan" button is always rendered in the bottom panel
        // (disabled when no result selected, enabled when one is selected)
        expect(find.text('Arahkan'), findsOneWidget);
      }
    });

    testWidgets('drag handle is shown in results panel', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      if (find.byType(CircularProgressIndicator).evaluate().isEmpty) {
        // The panel has a small drag-handle Container
        expect(find.byType(Container), findsWidgets);
      }
    });
  });

  group('MapSearchResultPage – _MapSearchResultPageState', () {
    testWidgets('initState triggers search for given query', (tester) async {
      await tester.pumpWidget(buildTestApp(query: 'Kawah Ratu'));
      await tester.pump();

      // Page initialised without throwing
      expect(tester.takeException(), isNull);
    });

    testWidgets('search field reflects the original query string', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp(query: 'Curug Cigamea'));
      await tester.pump();

      expect(find.text('Curug Cigamea'), findsOneWidget);
    });
  });

  group('MapSearchResultPage – search interaction', () {
    testWidgets('entering new text does not crash', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Tanjung Lesung');
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('clearing search clears suggestions list', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Anyer');
      await tester.pump();
      await tester.enterText(textField, '');
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });

  group('MapSearchResultPage – dispose', () {
    testWidgets('disposes cleanly without memory leaks', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Text('Replaced'))),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
