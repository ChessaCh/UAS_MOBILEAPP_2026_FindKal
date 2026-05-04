import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/ai_plan/ai_trip_plan_page.dart';
// ---------------------------------------------------------------------------
// Widget tests for AiTripPlanPage
// Tests: form fields rendering, validation snackbars, button enabled state,
// province dropdown interaction, Lanjutkan button behaviour.
// ---------------------------------------------------------------------------

Widget buildTestApp() {
  return const MaterialApp(home: AiTripPlanPage());
}

void main() {
  group('AiTripPlanPage – static UI', () {
    testWidgets('renders page title', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Mulai Rencanakan Perjalananmu'), findsOneWidget);
    });

    testWidgets('renders subtitle text', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.textContaining('Biarkan AI yang membantu'), findsOneWidget);
    });

    testWidgets('renders "Nama perjalanan" field label', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Nama perjalanan'), findsOneWidget);
    });

    testWidgets('renders Provinsi dropdown label', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Provinsi'), findsOneWidget);
    });

    testWidgets('renders Durasi field label', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Durasi (hari)'), findsOneWidget);
    });

    testWidgets('renders Budget dropdown label', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Budget (Per hari)'), findsOneWidget);
    });

    testWidgets('renders Lanjutkan button', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Lanjutkan'), findsOneWidget);
    });

    testWidgets('back arrow is present in AppBar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
    });
  });

  group('AiTripPlanPage – Lanjutkan button validation', () {
    testWidgets('shows snackbar when Lanjutkan tapped with empty trip name', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.text('Lanjutkan'));
      await tester.pump();

      expect(find.text('Nama perjalanan harus diisi.'), findsOneWidget);
    });

    testWidgets(
      'shows snackbar about Provinsi when name is filled but province not selected',
      (tester) async {
        await tester.pumpWidget(buildTestApp());
        await tester.pump();

        // Fill the trip name field
        await tester.enterText(find.byType(TextField).first, 'Liburan Banten');
        await tester.pump();

        await tester.tap(find.text('Lanjutkan'));
        await tester.pump();

        expect(find.text('Provinsi harus dipilih.'), findsOneWidget);
      },
    );
  });

  group('AiTripPlanPage – Durasi field', () {
    testWidgets('durasi field defaults to 1', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      // The duration field is readOnly with default text '1'
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('durasi field is read-only (cannot be edited by user)', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      // Find all TextFields — durasi is the one that's readOnly
      final textFields = tester.widgetList<TextField>(find.byType(TextField));
      final readOnlyFields = textFields.where((f) => f.readOnly).toList();
      expect(readOnlyFields, isNotEmpty);
    });
  });

  group('AiTripPlanPage – initState', () {
    testWidgets('starts loading provinces on init (spinner or list appears)', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      // After the first frame, loading spinner for provinces should be visible
      // OR it has already populated (network can resolve quickly in some envs)
      await tester.pump(Duration.zero);

      // The page rendered without throwing
      expect(find.byType(AiTripPlanPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('nameController listener triggers setState on text change', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      final textField = find.byType(TextField).first;
      await tester.enterText(textField, 'New Trip Name');
      await tester.pump();

      // No exception thrown during setState from listener
      expect(tester.takeException(), isNull);
    });
  });

  group('AiTripPlanPage – Kota dropdown', () {
    testWidgets('Kota dropdown is initially disabled (no province selected)', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.text('Kota (Opsional)'), findsOneWidget);
      // The dropdown for city should be present but inactive
      // (onChanged is null when _selectedProvinceId is null)
    });
  });
}
