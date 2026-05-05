import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Search Update Suggestion List Unit Tests', () {
    List<String> getSuggestions(String query, List<String> allData) {
      if (query.isEmpty) return [];
      return allData
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    test('Suggestion list memberikan data relevan saat query dimasukkan', () {
      // Set up
      final dummyData = ['Bear&Butter BSD', 'Kopi Kenangan', 'Cafe Kucing'];
      
      // Do
      final result1 = getSuggestions('bear', dummyData);
      final result2 = getSuggestions('kopi', dummyData);
      final result3 = getSuggestions('xyz', dummyData);

      // Expect
      expect(result1, contains('Bear&Butter BSD'));
      expect(result2, contains('Kopi Kenangan'));
      expect(result3, isEmpty);
    });
  });
}
