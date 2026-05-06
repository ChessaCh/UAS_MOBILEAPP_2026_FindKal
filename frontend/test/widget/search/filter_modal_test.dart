import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:findkal/homepage/search_overlay_page.dart';

final _dummyData = [
  {
    'id': 1,
    'userName': 'Wawanti',
    'usernameHandle': '@wawanti001',
    'userAvatar': 'W',
    'placeName': 'Bahasa Alam BSD',
    'rating': 4,
    'address': 'The Green, Cluster Manhattan B7/17 BSD City',
    'review': 'Makanan enak',
    'budget': 'Rp 50k - Rp 100k',
    'imagePaths': <String>[],
    'latitude': null,
    'longitude': null,
  },
  {
    'id': 2,
    'userName': 'Sabine',
    'usernameHandle': '@vi_enrose9',
    'userAvatar': 'S',
    'placeName': 'Bear&Butter BSD',
    'rating': 5,
    'address': 'Mall Ararasa BSD, Lantai Unit GC',
    'review': 'Kafenya lucu dan estetik.',
    'budget': 'Rp 50k - Rp 100k',
    'imagePaths': <String>[],
    'latitude': null,
    'longitude': null,
  },
  {
    'id': 3,
    'userName': 'Richard',
    'usernameHandle': '@user71726',
    'userAvatar': 'R',
    'placeName': 'Hygge Cafe BSD',
    'rating': 3,
    'address': 'Jl. BSD Grand Boulevard',
    'review': 'Favourite spot WFC.',
    'budget': 'Rp 50k - Rp 100k',
    'imagePaths': <String>[],
    'latitude': null,
    'longitude': null,
  },
];

Future<List<Map<String, dynamic>>> _fakeFetch() async => _dummyData;

void main() {
  group('Search Filter Modal Widget Tests', () {
    testWidgets('Triggers _showFilterModal and interacts with _applyFilter', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: SearchOverlayPage(fetchFn: _fakeFetch)),
      );

      // Wait for fake fetch and rendering to complete
      await tester.pumpAndSettle();

      // Tap the filter button (Icons.tune)
      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();

      // Verify the filter modal is shown
      expect(find.text("Filter Pencarian"), findsOneWidget);
      expect(find.text("Minimal Rating"), findsOneWidget);

      // Select 4.0+ rating chip
      await tester.tap(find.text("4.0+"));
      await tester.pump();

      // Tap "Terapkan" to apply filter and close modal
      await tester.tap(find.text("Terapkan"));
      await tester.pumpAndSettle();

      // Verify modal is closed
      expect(find.text("Filter Pencarian"), findsNothing);

      // Bear&Butter BSD has rating 5.0 so it should still appear (>= 4.0)
      // Hygge Cafe BSD has rating 3.0 so it should be filtered out
      expect(find.text('Bear&Butter BSD'), findsWidgets);
      expect(find.text('Hygge Cafe BSD'), findsNothing);
    });
  });
}
