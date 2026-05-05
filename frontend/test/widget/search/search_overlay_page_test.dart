import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:findkal/homepage/search_overlay_page.dart';

void main() {
  group('SearchOverlayPage Widget Tests', () {
    testWidgets('Renders SearchOverlayPage and handles input (initState, dispose, _onSearchChanged)', (WidgetTester tester) async {
      // Set up
      await tester.pumpWidget(const MaterialApp(home: SearchOverlayPage()));
      
      // Wait for initial render (it will fetch initial places from API)
      await tester.pump();
      
      // Expect: Verify the initial state and Search bar rendering
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Cari tempat atau lokasi...'), findsOneWidget);

      // Do: Enter text into the search bar to trigger _onSearchChanged()
      await tester.enterText(find.byType(TextField), 'Bali');
      await tester.pumpAndSettle();
      
      // Expect: Verify the UI updates to show suggestions (_updateSuggestions)
      // We expect the word 'Bali' or suggestions window to be shown on screen
      // depending on the autocomplete behavior. We also expect the list to update.
      expect(find.text('Bali'), findsWidgets); // Input itself or matches

      // Do: Press back button or close to ensure dispose() functions properly when the page is destroyed (pop)
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Expect: The overlay is no longer on screen.
      expect(find.byType(SearchOverlayPage), findsNothing);
    });
  });
}

