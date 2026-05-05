import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:findkal/main.dart' as app; // Import the main.dart application file
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Complete Search Place Flow Integration Test', () {
    testWidgets('Navigates through full search, suggestion, and filtering flow', (WidgetTester tester) async {
      // Set up
      // Start the application
      app.main(); 
      await tester.pumpAndSettle(const Duration(seconds: 3)); // Wait for app initialization and initial data fetch
      
      // Do
      // Trigger _openSearch() flow by tapping the Search Action Bar from HomePage
      await tester.tap(find.text("Mau ke mana hari ini?"));
      await tester.pumpAndSettle();
      
      // Expect that we landed on the `SearchOverlayPage`
      expect(find.text('Cari tempat atau lokasi...'), findsOneWidget);

      // Do
      // Trigger _onSearchChanged() by finding the TextField and entering a query
      await tester.enterText(find.byType(TextField), 'Bear');
      await tester.pumpAndSettle();
      
      // Expect
      // Verify the auto-suggestions update (_updateSuggestions) on the SearchOverlayPage
      // "Bear&Butter BSD" exists in your dummyUnggahans API mock.
      expect(find.text('Bear&Butter BSD'), findsWidgets);
      
      // Do
      // Clear the text to show the filter and list view results properly
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Tap the Filter icon to invoke _showFilterModal()
      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();

      // Select "4.0+" as minimum rating in the modal 
      await tester.tap(find.text('4.0+'));
      await tester.pumpAndSettle();

      // Set filter values and Apply to invoke _applyFilter()
      await tester.tap(find.text('Terapkan'));
      await tester.pumpAndSettle();

      // Expect
      // Verify the final search results update dynamically on the page conforming to the filter
      // (Bear&Butter BSD has 5.0 rating, so it should still be visible after 4.0+ filter)
      expect(find.text('Bear&Butter BSD'), findsWidgets);
      
      // Check that the filter modal is closed
      expect(find.text('Filter Pencarian'), findsNothing);
    });
  });
}


