import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/homepage/home.dart';

// ---------------------------------------------------------------------------
// Widget tests — Handle Pending Upload feature
// Covers: _handlePendingUpload()
// Tester: Arji
// ---------------------------------------------------------------------------

Widget buildTestApp({Future<void> Function()? pendingUpload}) => MaterialApp(
      home: HomePage(pendingUpload: pendingUpload),
      routes: {
        '/notification': (_) => const Scaffold(body: Text('Notifikasi')),
      },
    );

void main() {
  group('HomePage – _handlePendingUpload', () {
    testWidgets('shows "Mengunggah postingan..." snackbar when provided', (
      tester,
    ) async {
      final completer = Completer<void>();

      await tester.pumpWidget(
        buildTestApp(pendingUpload: () => completer.future),
      );
      await tester.pump(); // first frame — addPostFrameCallback scheduled
      await tester.pump(); // post-frame callback fires → snackbar shown

      expect(find.text('Mengunggah postingan...'), findsOneWidget);

      completer.complete();
      await tester.pump();
      await tester.pump(const Duration(seconds: 5));
      await tester.pump(const Duration(seconds: 20));
    });

    testWidgets('shows CircularProgressIndicator inside loading snackbar', (
      tester,
    ) async {
      final completer = Completer<void>();

      await tester.pumpWidget(
        buildTestApp(pendingUpload: () => completer.future),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);

      completer.complete();
      await tester.pump();
      await tester.pump(const Duration(seconds: 5));
      await tester.pump(const Duration(seconds: 20));
    });

    testWidgets('does not show pending upload snackbar when not provided', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Mengunggah postingan...'), findsNothing);

      await tester.pump(const Duration(seconds: 20));
    });
  });
}
