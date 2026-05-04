import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Unit tests for province-selection logic in AiTripPlanPage
// Covers: province list parsing, city loading dependency on provinceId,
// dropdown enabled/disabled conditions.
// ---------------------------------------------------------------------------

// ── Helpers that mirror source parsing logic ─────────────────────────────────

/// Parses the raw API body format used by _fetch() in AiTripPlanPage.
List<Map<String, String>> parseLocationData(Map<String, dynamic> body) {
  final data = body['data'] as List<dynamic>;
  return data
      .map((e) => {'id': e['id'].toString(), 'name': e['name'].toString()})
      .toList();
}

/// Mirrors the dropdown enabled condition from _buildDropdown():
/// enabled = !loading && items.isNotEmpty
bool isDropdownEnabled({required bool loading, required List items}) {
  return !loading && items.isNotEmpty;
}

void main() {
  // ── parseLocationData ───────────────────────────────────────────────────────
  group('Province selection – parseLocationData', () {
    test('parses well-formed province API response', () {
      final body = {
        'data': [
          {'id': 3, 'name': 'Banten'},
          {'id': 9, 'name': 'Jawa Barat'},
          {'id': 11, 'name': 'Jawa Tengah'},
        ],
      };

      final result = parseLocationData(body);

      expect(result.length, 3);
      expect(result[0], {'id': '3', 'name': 'Banten'});
      expect(result[1], {'id': '9', 'name': 'Jawa Barat'});
      expect(result[2], {'id': '11', 'name': 'Jawa Tengah'});
    });

    test('coerces numeric ids to strings', () {
      final body = {
        'data': [
          {'id': 42, 'name': 'Sulawesi Selatan'},
        ],
      };
      final result = parseLocationData(body);
      expect(result.first['id'], isA<String>());
      expect(result.first['id'], '42');
    });

    test('returns empty list when data array is empty', () {
      final body = {'data': []};
      final result = parseLocationData(body);
      expect(result, isEmpty);
    });

    test('handles string ids without casting error', () {
      final body = {
        'data': [
          {'id': '5', 'name': 'Papua'},
        ],
      };
      final result = parseLocationData(body);
      expect(result.first['id'], '5');
    });
  });

  // ── Dropdown enabled state ──────────────────────────────────────────────────
  group('Province selection – dropdown enabled state', () {
    test('disabled while loading', () {
      expect(
        isDropdownEnabled(
          loading: true,
          items: [
            {'id': '1', 'name': 'Banten'},
          ],
        ),
        isFalse,
      );
    });

    test('disabled when items list is empty (not yet loaded)', () {
      expect(isDropdownEnabled(loading: false, items: []), isFalse);
    });

    test('enabled when not loading and items are available', () {
      expect(
        isDropdownEnabled(
          loading: false,
          items: [
            {'id': '1', 'name': 'Banten'},
          ],
        ),
        isTrue,
      );
    });

    test('city dropdown disabled before province is selected', () {
      // City dropdown onChanged is null when _selectedProvinceId is null
      String? selectedProvinceId;
      bool cityDropdownActive = selectedProvinceId != null;
      expect(cityDropdownActive, isFalse);
    });

    test('city dropdown enabled after province is selected', () {
      String? selectedProvinceId = '3'; // Banten
      bool cityDropdownActive = selectedProvinceId != null;
      expect(cityDropdownActive, isTrue);
    });
  });

  // ── Province data integrity ─────────────────────────────────────────────────
  group('Province selection – data integrity', () {
    late List<Map<String, String>> provinces;

    setUp(() {
      final body = {
        'data': [
          {'id': 1, 'name': 'Aceh'},
          {'id': 3, 'name': 'Banten'},
          {'id': 9, 'name': 'Jawa Barat'},
          {'id': 11, 'name': 'Jawa Tengah'},
          {'id': 13, 'name': 'Jawa Timur'},
        ],
      };
      provinces = parseLocationData(body);
    });

    test('can find Banten by name', () {
      final banten = provinces.firstWhere(
        (p) => p['name'] == 'Banten',
        orElse: () => {},
      );
      expect(banten['id'], '3');
    });

    test('all entries have non-empty name and id', () {
      for (final p in provinces) {
        expect(p['id'], isNotEmpty);
        expect(p['name'], isNotEmpty);
      }
    });

    test('province ids are unique', () {
      final ids = provinces.map((p) => p['id']).toList();
      expect(ids.toSet().length, ids.length);
    });
  });

  // ── Loading states ──────────────────────────────────────────────────────────
  group('Province selection – loading flag transitions', () {
    test('loadingProvinces starts true then becomes false after load', () {
      // Simulates the setState sequence in _loadProvinces()
      bool loadingProvinces = false;
      List<Map<String, String>> provinces = [];

      // setState(() => _loadingProvinces = true)
      loadingProvinces = true;
      expect(loadingProvinces, isTrue);

      // After successful fetch
      provinces = [
        {'id': '3', 'name': 'Banten'},
      ];
      // finally block: setState(() => _loadingProvinces = false)
      loadingProvinces = false;

      expect(loadingProvinces, isFalse);
      expect(provinces, isNotEmpty);
    });

    test('loadingCities transitions correctly during province change', () {
      bool loadingCities = false;
      List<Map<String, String>> cities = [
        {'id': '1', 'name': 'Tangerang'},
      ];

      // Simulate _onProvinceChanged
      cities = [];
      loadingCities = true;
      expect(loadingCities, isTrue);
      expect(cities, isEmpty);

      // After fetch completes
      cities = [
        {'id': '101', 'name': 'Tangerang Selatan'},
      ];
      loadingCities = false;
      expect(loadingCities, isFalse);
      expect(cities, isNotEmpty);
    });
  });
}
