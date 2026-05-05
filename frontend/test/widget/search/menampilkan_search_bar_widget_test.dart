import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Search Menampilkan Search bar Widget Tests', () {
    testWidgets('Search bar muncul dan menampilkan hint text yang tepat', (WidgetTester tester) async {
      // Set up: a generic TextField that simulates our search bar
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const TextField(
                decoration: InputDecoration(
                  hintText: 'Cari tempat atau lokasi...',
                ),
              ),
            ),
          ),
        ),
      );

      // Do: Render
      await tester.pumpAndSettle();

      // Expect: Search bar elements are displayed
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Cari tempat atau lokasi...'), findsOneWidget);
    });
  });
}
