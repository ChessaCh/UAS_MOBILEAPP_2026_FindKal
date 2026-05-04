import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/ai_plan/ai_trip_detail_page.dart';

// ---------------------------------------------------------------------------
// Widget tests for MapPreviewCard and AiTripDetailPage
// Tests: empty/no-coordinate state, transport card rendering, editPlan sheet,
// and _buildTransportCard appearance.
// ---------------------------------------------------------------------------

Widget buildTestApp({required Widget child}) {
  return MaterialApp(home: child);
}

// ── Sample data ───────────────────────────────────────────────────────────────

const List<Map<String, dynamic>> placesWithCoords = [
  {
    'time': '09:00',
    'title': 'Pantai Anyer',
    'details': 'Pantai pasir putih di Banten.',
    'image_url': null,
    'latitude': -6.047,
    'longitude': 105.934,
  },
  {
    'time': '14:00',
    'title': 'Curug Cigamea',
    'details': 'Air terjun indah di pedalaman Banten.',
    'image_url': null,
    'latitude': -6.700,
    'longitude': 106.600,
  },
];

const List<Map<String, dynamic>> placesWithoutCoords = [
  {
    'time': '09:00',
    'title': 'Tempat Tanpa Koordinat',
    'details': 'Tidak ada lat/lng.',
    'image_url': null,
  },
];

void main() {
  // ── MapPreviewCard ──────────────────────────────────────────────────────────
  group('MapPreviewCard – no coordinates', () {
    testWidgets('shows fallback "Peta tidak tersedia" when no lat/lng', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Scaffold(body: MapPreviewCard(items: placesWithoutCoords)),
        ),
      );
      await tester.pump();

      expect(find.text('Peta tidak tersedia'), findsOneWidget);
    });

    testWidgets('shows helper text about coordinates when no lat/lng', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Scaffold(body: MapPreviewCard(items: placesWithoutCoords)),
        ),
      );
      await tester.pump();

      expect(find.textContaining('koordinat'), findsOneWidget);
    });

    testWidgets('shows map icon in fallback state', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Scaffold(body: MapPreviewCard(items: placesWithoutCoords)),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.map_outlined), findsOneWidget);
    });

    testWidgets('shows fallback when items list is empty', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const Scaffold(body: MapPreviewCard(items: [])),
        ),
      );
      await tester.pump();

      expect(find.text('Peta tidak tersedia'), findsOneWidget);
    });
  });

  // ── AiTripDetailPage – static content ──────────────────────────────────────
  group('AiTripDetailPage – static UI', () {
    testWidgets('renders trip name in heading', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: AiTripDetailPage(
            tripName: 'Liburan Keluarga',
            places: placesWithoutCoords,
          ),
        ),
      );
      await tester.pump();

      expect(find.textContaining('Liburan Keluarga'), findsOneWidget);
    });

    testWidgets('renders "Tempat" section label', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: AiTripDetailPage(
            tripName: 'Trip Test',
            places: placesWithoutCoords,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Tempat'), findsOneWidget);
    });

    testWidgets('renders "Selesai" button', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: AiTripDetailPage(
            tripName: 'Trip Test',
            places: placesWithoutCoords,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Selesai'), findsOneWidget);
    });

    testWidgets('renders "Ubah rencana" button', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: AiTripDetailPage(
            tripName: 'Trip Test',
            places: placesWithoutCoords,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Ubah rencana'), findsOneWidget);
    });

    testWidgets('renders timeline items for each place', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: AiTripDetailPage(
            tripName: 'Trip Test',
            places: placesWithoutCoords,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Tempat Tanpa Koordinat'), findsOneWidget);
    });

    testWidgets('renders time label for each place', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: AiTripDetailPage(
            tripName: 'Trip Test',
            places: placesWithoutCoords,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('09:00'), findsOneWidget);
    });
  });

  // ── _editPlan bottom sheet ──────────────────────────────────────────────────
  group('AiTripDetailPage – _editPlan()', () {
    testWidgets('tapping "Ubah rencana" opens bottom sheet', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: AiTripDetailPage(
            tripName: 'Trip Test',
            places: placesWithoutCoords,
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Ubah rencana'));
      await tester.pumpAndSettle();

      expect(find.text('Ubah Rencana'), findsOneWidget); // sheet title
    });

    testWidgets('edit sheet shows "Simpan Perubahan" button', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: AiTripDetailPage(
            tripName: 'Trip Test',
            places: placesWithoutCoords,
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Ubah rencana'));
      await tester.pumpAndSettle();

      expect(find.text('Simpan Perubahan'), findsOneWidget);
    });

    testWidgets('tapping "Simpan Perubahan" closes the sheet', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: AiTripDetailPage(
            tripName: 'Trip Test',
            places: placesWithoutCoords,
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Ubah rencana'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Simpan Perubahan'));
      await tester.pumpAndSettle();

      // Sheet is gone; "Ubah rencana" button on main page is back
      expect(find.text('Ubah rencana'), findsOneWidget);
      expect(find.text('Simpan Perubahan'), findsNothing);
    });

    testWidgets('edit sheet shows "Destinasi 1" label for first place', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: AiTripDetailPage(
            tripName: 'Trip',
            places: placesWithoutCoords,
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Ubah rencana'));
      await tester.pumpAndSettle();

      expect(find.text('Destinasi 1'), findsOneWidget);
    });
  });

  // ── Transport section ───────────────────────────────────────────────────────
  group('AiTripDetailPage – _buildTransportCard', () {
    testWidgets('shows "Bisa naik transportasi ini!" heading', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: AiTripDetailPage(
            tripName: 'Trip',
            places: placesWithoutCoords,
          ),
        ),
      );
      await tester.pump();

      // Scroll down to reach the transport section
      await tester.dragUntilVisible(
        find.text('Bisa naik transportasi ini!'),
        find.byType(SingleChildScrollView).first,
        const Offset(0, -200),
      );

      expect(find.text('Bisa naik transportasi ini!'), findsOneWidget);
    });

    testWidgets('renders Motor transport card', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: AiTripDetailPage(
            tripName: 'Trip',
            places: placesWithoutCoords,
          ),
        ),
      );
      await tester.pump();

      await tester.dragUntilVisible(
        find.text('Motor').first,
        find.byType(SingleChildScrollView).first,
        const Offset(0, -200),
      );

      expect(find.text('Motor'), findsWidgets);
    });

    testWidgets('renders Mobil transport card', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: AiTripDetailPage(
            tripName: 'Trip',
            places: placesWithoutCoords,
          ),
        ),
      );
      await tester.pump();

      await tester.dragUntilVisible(
        find.text('Mobil').first,
        find.byType(SingleChildScrollView).first,
        const Offset(0, -200),
      );

      expect(find.text('Mobil'), findsWidgets);
    });

    testWidgets('transport card shows "Menit" label', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: AiTripDetailPage(
            tripName: 'Trip',
            places: placesWithoutCoords,
          ),
        ),
      );
      await tester.pump();

      await tester.dragUntilVisible(
        find.text('Menit').first,
        find.byType(SingleChildScrollView).first,
        const Offset(0, -200),
      );

      expect(find.text('Menit'), findsWidgets);
    });

    testWidgets('transport card shows "Lama waktu tempuh:" label', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: AiTripDetailPage(
            tripName: 'Trip',
            places: placesWithoutCoords,
          ),
        ),
      );
      await tester.pump();

      await tester.dragUntilVisible(
        find.text('Lama waktu tempuh:').first,
        find.byType(SingleChildScrollView).first,
        const Offset(0, -200),
      );

      expect(find.text('Lama waktu tempuh:'), findsWidgets);
    });
  });
}
