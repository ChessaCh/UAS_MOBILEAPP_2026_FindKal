import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:findkal/homepage/search_overlay_page.dart';

void main() {
  group('Search Filter Modal Widget Tests', () {
    testWidgets('Triggers _showFilterModal and interacts with _applyFilter', (WidgetTester tester) async {
      // Set up
      await tester.pumpWidget(const MaterialApp(home: SearchOverlayPage()));
      
      // Wait for initial API fetch and rendering
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Do
      // Tap the filter button (It's an icon with Icons.tune inside SearchOverlayPage)
      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();
      
      // Expect
      // Verify the filter modal is shown on screen
      expect(find.text("Filter Pencarian"), findsOneWidget);
      expect(find.text("Minimal Rating"), findsOneWidget);
      
      // Do
      // Select a filter criteria in the modal (4.0+)
      await tester.tap(find.text("4.0+"));
      await tester.pump(); // We didn't animate out yet, just state change

      // Tap the "Terapkan" button inside the modal to trigger _applyFilter() and close it
      await tester.tap(find.text("Terapkan"));
      await tester.pumpAndSettle(const Duration(milliseconds: 300));
      
      // Expect
      // Verify modal is closed properly
      expect(find.text("Filter Pencarian"), findsNothing);
      
      // Verify that Bear&Butter BSD is still rendered because its rating is 5.0 (>= 4.0)
      // Since dummy data provides it and it renders using `PlaceSummary`
      expect(find.text('Bear&Butter BSD'), findsWidgets);
    });
  });
}


