import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Search Filtering Unit Tests', () {
    List<Map<String, dynamic>> applyFilter(
      List<Map<String, dynamic>> places,
      double minRating,
    ) {
      return places.where((place) => (place['rating'] as double) >= minRating).toList();
    }

    test('Filter rating berhasil diterapkan menghasilkan data yang valid', () {
      // Set up
      final dummyPlaces = [
        {'name': 'Cafe A', 'rating': 3.5},
        {'name': 'Cafe B', 'rating': 4.0},
        {'name': 'Cafe C', 'rating': 5.0},
      ];

      // Do
      final result4plus = applyFilter(dummyPlaces, 4.0);

      // Expect
      expect(result4plus.length, 2);
      expect(result4plus.any((p) => p['name'] == 'Cafe A'), false);
      expect(result4plus.any((p) => p['name'] == 'Cafe C'), true);
    });
  });
}
