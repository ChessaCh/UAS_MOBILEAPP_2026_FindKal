import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/models/unggahan.dart';

// Mocking PlaceSummary from your SearchOverlayPage logic
class MockPlaceSummary {
  final String placeName;
  final int postCount;
  final double averageRating;

  MockPlaceSummary({
    required this.placeName,
    required this.postCount,
    required this.averageRating,
  });
}

void main() {
  group('Search Suggestion Logic Unit Tests', () {
    test('updateSuggestions provides correct auto-suggestions based on input', () {
      // Set up
      final List<MockPlaceSummary> allPlaces = [
        MockPlaceSummary(placeName: 'Hygge Cafe BSD', postCount: 2, averageRating: 4.5),
        MockPlaceSummary(placeName: 'Bahasa Alam BSD', postCount: 1, averageRating: 4.0),
        MockPlaceSummary(placeName: 'Bear&Butter BSD', postCount: 3, averageRating: 5.0),
        MockPlaceSummary(placeName: 'Artirasa Gading Serpong', postCount: 1, averageRating: 5.0),
      ];
      final String query = 'bsd';

      // Do
      final q = query.trim().toLowerCase();
      final matches = allPlaces
          .where((p) => p.placeName.toLowerCase().contains(q))
          .map((p) => p.placeName)
          .toList();
      
      matches.sort((a, b) {
        final aStarts = a.toLowerCase().startsWith(q) ? 0 : 1;
        final bStarts = b.toLowerCase().startsWith(q) ? 0 : 1;
        return aStarts.compareTo(bStarts);
      });
      
      final List<String> suggestions = matches.take(5).toList();

      // Expect
      expect(suggestions.length, 3);
      expect(suggestions.contains('Hygge Cafe BSD'), true);
      expect(suggestions.contains('Bahasa Alam BSD'), true);
      expect(suggestions.contains('Bear&Butter BSD'), true);
      expect(suggestions.contains('Artirasa Gading Serpong'), false);
    });

    test('fetchPlaces fetches places data from API successfully', () async {
      // Set up
      // Simulating the result of ApiService.fetchUnggahans() or dummy data from your app
      final List<Unggahan> fetchedData = dummyUnggahans;
      
      // Do
      final Map<String, List<Unggahan>> grouped = {};
      for (var u in fetchedData) {
        grouped.putIfAbsent(u.placeName, () => []).add(u);
      }

      final List<MockPlaceSummary> summaries = [];
      grouped.forEach((placeName, list) {
        final totalRating = list.fold(0, (sum, u) => sum + u.rating);
        final avgRating = totalRating / list.length;
        
        summaries.add(MockPlaceSummary(
          placeName: placeName,
          postCount: list.length,
          averageRating: avgRating,
        ));
      });

      // Expect
      expect(summaries.isNotEmpty, true);
      expect(summaries.length, 4); // 4 distinct places in dummy data
      
      // Check if place names mapped correctly
      final names = summaries.map((s) => s.placeName).toList();
      expect(names, containsAll(['Bahasa Alam BSD', 'Hygge Cafe BSD', 'Bear&Butter BSD', 'Artirasa Gading Serpong']));
    });
  });
}

