import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:findkal/map/map_direction_page.dart';

// ---------------------------------------------------------------------------
// Widget-level tests for MapDirectionPage (run with `flutter test`).
// Two mock strategies are used depending on what each group tests:
//
//  • never-completing  — _loadRoute() stays suspended at checkPermission(),
//                        widget stays in loading state; no FlutterMap issues.
//  • deniedForever (1) — _loadRoute() exits early with an error message and
//                        _buildMap() returns a plain Container (no FlutterMap),
//                        so the error-state UI can be asserted safely.
// ---------------------------------------------------------------------------

const _kGeolocatorChannel = MethodChannel('flutter.baseflow.com/geolocator');
const _kDestination = LatLng(-6.2828, 106.6376);
const _kDestinationName = 'Bear&Butter BSD';

Widget _buildApp() => MaterialApp(
      routes: {'/home': (_) => const Scaffold(body: Text('Home'))},
      home: const MapDirectionPage(
        destinationName: _kDestinationName,
        destination: _kDestination,
        // No destinationAddress → _loadRoute() is called directly (no HTTP geocoding)
      ),
    );

void _mockNeverCompletes() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_kGeolocatorChannel, (_) {
    return Completer<Object?>().future;
  });
}

void _mockDeniedForever() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_kGeolocatorChannel, (call) async {
    switch (call.method) {
      case 'checkPermission':
      case 'requestPermission':
        return 1; // LocationPermission.deniedForever
      default:
        return null;
    }
  });
}

void _clearMock() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_kGeolocatorChannel, null);
}

void main() {
  // ── Loading state (geolocator never resolves) ────────────────────────────
  group('MapDirectionPage – loading state', () {
    setUp(_mockNeverCompletes);
    tearDown(_clearMock);

    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(MapDirectionPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows loading overlay with spinner and label', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.text('Mencari rute...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('destination name is pre-filled in search field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.text(_kDestinationName), findsOneWidget);
    });

    testWidgets('back button is rendered', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });

    testWidgets('Cari button is rendered', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.text('Cari'), findsOneWidget);
    });

    testWidgets('directions icon is visible in the search bar', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byIcon(Icons.directions), findsOneWidget);
    });

    testWidgets('BottomNavigationBar is rendered with Map tab selected',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.currentIndex, 1); // Map tab
      expect(navBar.items.length, 3);
    });
  });

  // ── Location permanently denied ──────────────────────────────────────────
  group('MapDirectionPage – location permanently denied', () {
    setUp(_mockDeniedForever);
    tearDown(_clearMock);

    testWidgets('shows location denied error message', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Izin lokasi ditolak'), findsOneWidget);
    });

    testWidgets('shows Coba Lagi retry button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Coba Lagi'), findsOneWidget);
    });

    testWidgets('loading overlay is gone after permission error', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Mencari rute...'), findsNothing);
    });

    testWidgets('destination name still shown in search field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text(_kDestinationName), findsOneWidget);
    });

    testWidgets('back button still rendered in error state', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });

    testWidgets('no route info card shown when error', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Info card shows transport chips — none should be visible on error
      expect(find.text('Mobil'), findsNothing);
      expect(find.text('Motor'), findsNothing);
      expect(find.text('Jalan'), findsNothing);
    });
  });
}
