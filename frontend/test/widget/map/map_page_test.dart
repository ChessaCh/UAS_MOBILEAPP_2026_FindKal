import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/map/map_page.dart';

// ---------------------------------------------------------------------------
// Widget tests for MapPage
// Tests: search bar rendering, bottom nav bar, FAB presence, initial map load.
// NOTE: FlutterMap tile loading is skipped in test environment — we only
// verify the widget structure, not tile rendering.
// ---------------------------------------------------------------------------

Widget buildTestApp() {
  return const MaterialApp(home: MapPage());
}

void main() {
  group('MapPage - static UI', () {
    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(MapPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('search bar hint text "Cari lokasi..." is present', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Cari lokasi...'), findsOneWidget);
    });

    testWidgets('renders "Cari" search button', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Cari'), findsOneWidget);
    });

    testWidgets('renders search icon in search bar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('renders back arrow button', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });
  });

  group('MapPage - BottomNavigationBar', () {
    testWidgets('has a BottomNavigationBar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('BottomNavigationBar has Home, Map, and Profile items', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget); // active Map
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('Map tab is the selected tab (index 1)', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.currentIndex, 1);
    });
  });

  group('MapPage - FloatingActionButton', () {
    testWidgets('has a "my location" FAB', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.my_location), findsOneWidget);
    });
  });

  group('MapPage - search interaction', () {
    testWidgets('entering text in search bar does not throw', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Pantai Anyer');
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('clearing search clears suggestions (no exception)', (
      tester,
    ) async {
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

  group('MapPage - initState', () {
    testWidgets('initState calls _requestLocationAndMove without crashing', (
      tester,
    ) async {
      // Geolocator will fail gracefully in tests (no device GPS)
      await tester.pumpWidget(buildTestApp());
      await tester.pump(const Duration(seconds: 1));

      expect(tester.takeException(), isNull);
    });
  });
}
