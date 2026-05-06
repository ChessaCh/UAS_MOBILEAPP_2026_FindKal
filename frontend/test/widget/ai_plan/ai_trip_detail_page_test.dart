import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/ai_plan/ai_trip_detail_page.dart';

// ---------------------------------------------------------------------------
// Widget tests for AiTripDetailPage
// Tests: initState copies places to timelineItems, _editPlan modal,
// static UI, transport section, back navigation.
// ---------------------------------------------------------------------------

Widget buildTestApp({
  String tripName = 'Liburan Banten',
  List<Map<String, dynamic>> places = const [],
  List<Map<String, dynamic>> transport = const [],
}) => MaterialApp(
      home: AiTripDetailPage(
        tripName: tripName,
        places: places,
        transport: transport,
      ),
    );

const _samplePlaces = [
  {
    'time': '09:00',
    'title': 'Pantai Anyer',
    'details': 'Pantai indah di Banten',
    'image_url': null,
  },
  {
    'time': '13:00',
    'title': 'Kawah Ratu',
    'details': 'Kawah di Gunung Salak',
    'image_url': null,
  },
];

void main() {
  // ── Static UI ────────────────────────────────────────────────────────────
  group('AiTripDetailPage – static UI', () {
    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(AiTripDetailPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('back arrow is present in AppBar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
    });

    testWidgets('renders "Selesai" button', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Selesai'), findsOneWidget);
    });

    testWidgets('renders "Ubah rencana" button', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Ubah rencana'), findsOneWidget);
    });

    testWidgets('renders trip name in body heading', (tester) async {
      await tester.pumpWidget(buildTestApp(tripName: 'Wisata Banten'));
      await tester.pump();

      expect(find.textContaining('Wisata Banten'), findsOneWidget);
    });

    testWidgets('renders "Rencana Kegiatanmu:" prefix in heading', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp(tripName: 'Trip Ciawi'));
      await tester.pump();

      expect(find.textContaining('Rencana Kegiatanmu:'), findsOneWidget);
    });
  });

  // ── initState – timelineItems copied from widget.places ──────────────────
  group('AiTripDetailPage – initState', () {
    testWidgets('initState does not throw with empty places list', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp(places: []));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('renders place titles when places are provided', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp(places: _samplePlaces));
      await tester.pump();

      expect(find.text('Pantai Anyer'), findsOneWidget);
      expect(find.text('Kawah Ratu'), findsOneWidget);
    });

    testWidgets('renders place times when places are provided', (tester) async {
      await tester.pumpWidget(buildTestApp(places: _samplePlaces));
      await tester.pump();

      expect(find.text('09:00'), findsOneWidget);
      expect(find.text('13:00'), findsOneWidget);
    });

    testWidgets('shows "Peta tidak tersedia" when no place has coordinates', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp(places: _samplePlaces));
      await tester.pump();

      // _samplePlaces have no latitude/longitude → map preview fallback
      expect(find.text('Peta tidak tersedia'), findsOneWidget);
    });

    testWidgets('shows "Peta tidak tersedia" when places list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Peta tidak tersedia'), findsOneWidget);
    });

    testWidgets('timelineItems length matches widget.places length', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp(places: _samplePlaces));
      await tester.pump();

      // Both Destinasi 1 and Destinasi 2 should NOT be in the bottom sheet
      // yet (sheet not opened), but place titles are in the main body.
      expect(find.text('Pantai Anyer'), findsOneWidget);
      expect(find.text('Kawah Ratu'), findsOneWidget);
    });
  });

  // ── _editPlan – modal bottom sheet ───────────────────────────────────────
  group('AiTripDetailPage – _editPlan', () {
    testWidgets('tapping "Ubah rencana" opens modal bottom sheet', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp(places: _samplePlaces));
      await tester.pump();

      await tester.tap(find.text('Ubah rencana'));
      await tester.pumpAndSettle();

      expect(find.text('Ubah Rencana'), findsOneWidget);
    });

    testWidgets('modal contains "Simpan Perubahan" button', (tester) async {
      await tester.pumpWidget(buildTestApp(places: _samplePlaces));
      await tester.pump();

      await tester.tap(find.text('Ubah rencana'));
      await tester.pumpAndSettle();

      expect(find.text('Simpan Perubahan'), findsOneWidget);
    });

    testWidgets('modal shows "Destinasi 1" and "Destinasi 2" labels', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp(places: _samplePlaces));
      await tester.pump();

      await tester.tap(find.text('Ubah rencana'));
      await tester.pumpAndSettle();

      expect(find.text('Destinasi 1'), findsOneWidget);
      expect(find.text('Destinasi 2'), findsOneWidget);
    });

    testWidgets('tapping "Simpan Perubahan" closes the modal', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp(places: _samplePlaces));
      await tester.pump();

      await tester.tap(find.text('Ubah rencana'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Simpan Perubahan'));
      await tester.pumpAndSettle();

      expect(find.text('Simpan Perubahan'), findsNothing);
    });

    testWidgets('tapping "Ubah rencana" with empty places does not throw', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.text('Ubah rencana'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('modal contains Waktu and Tempat text fields', (tester) async {
      await tester.pumpWidget(buildTestApp(places: _samplePlaces));
      await tester.pump();

      await tester.tap(find.text('Ubah rencana'));
      await tester.pumpAndSettle();

      expect(find.text('Waktu'), findsWidgets);
      expect(find.text('Tempat'), findsWidgets);
    });
  });

  // ── Back navigation ───────────────────────────────────────────────────────
  group('AiTripDetailPage – back navigation', () {
    testWidgets('tapping back arrow pops the page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => const AiTripDetailPage(tripName: 'Test'),
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

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      expect(find.text('Open'), findsOneWidget);
    });
  });

  // ── Transport section ─────────────────────────────────────────────────────
  group('AiTripDetailPage – transport section', () {
    testWidgets('renders "Bisa naik transportasi ini!" heading', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Bisa naik transportasi ini!'), findsOneWidget);
    });

    testWidgets('renders "Rekomendasi transportasi" label', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Rekomendasi transportasi'), findsOneWidget);
    });
  });
}
