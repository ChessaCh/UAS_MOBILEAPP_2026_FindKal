import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Search Input Handling Widget Tests', () {
    testWidgets('Input text dapat diketik dan divalidasi state-nya', (WidgetTester tester) async {
      // Set up
      String capturedText = '';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              onChanged: (val) {
                capturedText = val;
              },
            ),
          ),
        ),
      );

      // Do: Enter text 'Kopi'
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Kopi');
      await tester.pump();

      // Expect: Text is captured properly
      expect(find.text('Kopi'), findsOneWidget);
      expect(capturedText, 'Kopi');
    });
  });
}
