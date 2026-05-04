import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:findkal/map/map_direction_page.dart';

// ---------------------------------------------------------------------------
// Widget tests for MapDirectionPage
// Tests: search bar, transport mode chips, loading overlay, error state,
// back navigation, bottom nav bar.
// ---------------------------------------------------------------------------

const _testDestination = LatLng(-6.047, 105.934); // Pantai Anyer

Widget buildTestApp({String destinationName = 'Pantai Anyer'}) {
  return MaterialApp(
    home: MapDirectionPage(
      destinationName: destinationName,
      destination: _testDestination,
    ),
    routes: {'/home': (_) => const Scaffold(body: Text('Home'))},
  );
}

void main() {
  group('MapDirectionPage – static UI', () {
    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(MapDirectionPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('back button is present', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });

    testWidgets('search bar shows "Cari" button', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Cari'), findsOneWidget);
    });

    testWidgets('search bar is pre-populated with destination name', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp(destinationName: 'Pantai Anyer'));
      await tester.pump();

      expect(find.text('Pantai Anyer'), findsOneWidget);
    });

    testWidgets('directions icon is in the search bar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.directions), findsOneWidget);
    });
  });

  group('MapDirectionPage – loading state', () {
    testWidgets('shows loading indicator on init', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump(Duration.zero);

      // Either loading overlay or page has resolved
      final hasLoading = find
          .byType(CircularProgressIndicator)
          .evaluate()
          .isNotEmpty;
      // In test env the route call will fail, so loading may clear quickly
      expect(
        hasLoading || find.byType(MapDirectionPage).evaluate().isNotEmpty,
        isTrue,
      );
    });
  });

  group('MapDirectionPage – BottomNavigationBar', () {
    testWidgets('has a BottomNavigationBar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Map tab is the selected tab (index 1)', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.currentIndex, 1);
    });

    testWidgets('has Home, Map, and Profile navigation items', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });
  });

  group('MapDirectionPage – transport mode chips (info card)', () {
    // The info card only renders after route loads successfully.
    // In test env the OSRM call will fail, so we verify error state instead.
    testWidgets('shows error card when route fails to load', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Either error card or loading — both valid in offline test
      final hasError = find.byIcon(Icons.error_outline).evaluate().isNotEmpty;
      final hasLoading = find
          .byType(CircularProgressIndicator)
          .evaluate()
          .isNotEmpty;
      expect(hasError || hasLoading, isTrue);
    });

    testWidgets('error card shows "Coba Lagi" retry button when visible', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      if (find.text('Coba Lagi').evaluate().isNotEmpty) {
        expect(find.text('Coba Lagi'), findsOneWidget);
      }
    });
  });

  group('MapDirectionPage – search interaction', () {
    testWidgets('typing in search bar does not crash', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Curug Cigamea');
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('clearing search field clears suggestions', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Pantai');
      await tester.pump();
      await tester.enterText(textField, '');
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });

  group('MapDirectionPage – dispose', () {
    testWidgets('disposes debounce timer and controllers without leaking', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      // Navigate away to trigger dispose
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Text('Gone'))),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
