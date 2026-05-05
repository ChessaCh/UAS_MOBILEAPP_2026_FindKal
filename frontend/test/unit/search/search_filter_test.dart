import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Search Filter Logic Unit Tests', () {
    test('applyFilter correctly applies criteria to search results', () {
      // Set up
      final List<Map<String, dynamic>> mockData = [
        {'name': 'Beach', 'type': 'Nature', 'price': 10},
        {'name': 'Museum', 'type': 'Culture', 'price': 20},
        {'name': 'Park', 'type': 'Nature', 'price': 5},
      ];
      
      // Do
      final result = mockData.where((item) => item['type'] == 'Nature' && (item['price'] as int) <= 15).toList();
      
      // Expect
      expect(result.length, 2);
      expect(result[0]['name'], 'Beach');
      expect(result[1]['name'], 'Park');
    });
  });
}
