import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Search Fetch Places Unit Tests', () {
    Future<List<Map<String, dynamic>>> fetchMockPlaces() async {
      // Mensimulasikan pemanggilan API (fetch places)
      await Future.delayed(const Duration(milliseconds: 100));
      return [
        {'id': 1, 'name': 'Bear&Butter BSD', 'rating': 5.0},
        {'id': 2, 'name': 'Kopi Kenangan', 'rating': 4.5},
      ];
    }

    test('Data tempat (places) berhasil diambil dari mock API call', () async {
      // Do
      final places = await fetchMockPlaces();

      // Expect
      expect(places.length, 2);
      expect(places.first['name'], 'Bear&Butter BSD');
      expect(places.first['rating'], 5.0);
    });
  });
}
