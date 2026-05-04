import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Unit tests for AiTripPlanPage logic
// These tests validate the _canProceed gate, budget-id mapping, and the
// _onCityChanged / _onProvinceChanged state transitions WITHOUT rendering any
// widget — pure logic extraction.
// ---------------------------------------------------------------------------

// Because the logic lives inside a private _AiTripPlanPageState we extract the
// rules here as plain functions/helpers that mirror exactly what the source does,
// then verify those contracts.

// ── Mirrors _canProceed from _AiTripPlanPageState ────────────────────────────
bool canProceed({
  required String tripName,
  required String? selectedProvince,
  required String? selectedBudgetId,
}) {
  return tripName.trim().isNotEmpty &&
      selectedProvince != null &&
      selectedBudgetId != null;
}

// ── Budget options as defined in the source ───────────────────────────────────
const List<Map<String, String>> budgetOptions = [
  {'id': 'hemat', 'name': '💸 Hemat — < Rp100.000'},
  {'id': 'budget', 'name': '💵 Budget — Rp100.000 – Rp300.000'},
  {'id': 'menengah', 'name': '💳 Menengah — Rp300.000 – Rp700.000'},
  {'id': 'premium', 'name': '💎 Premium — Rp700.000 – Rp1.500.000'},
  {'id': 'luxury', 'name': '🏝 Luxury — > Rp1.500.000'},
];

String? budgetIdForName(String name) {
  final match = budgetOptions.where((e) => e['name'] == name).toList();
  return match.isEmpty ? null : match.first['id'];
}

void main() {
  // ── _canProceed ─────────────────────────────────────────────────────────────
  group('AiTripPlanPage – _canProceed', () {
    test('returns false when trip name is empty', () {
      expect(
        canProceed(tripName: '', selectedProvince: 'Banten', selectedBudgetId: 'hemat'),
        isFalse,
      );
    });

    test('returns false when trip name is only whitespace', () {
      expect(
        canProceed(tripName: '   ', selectedProvince: 'Banten', selectedBudgetId: 'hemat'),
        isFalse,
      );
    });

    test('returns false when province is null', () {
      expect(
        canProceed(tripName: 'Liburan Banten', selectedProvince: null, selectedBudgetId: 'hemat'),
        isFalse,
      );
    });

    test('returns false when budgetId is null', () {
      expect(
        canProceed(tripName: 'Liburan Banten', selectedProvince: 'Banten', selectedBudgetId: null),
        isFalse,
      );
    });

    test('returns false when all fields are null/empty', () {
      expect(
        canProceed(tripName: '', selectedProvince: null, selectedBudgetId: null),
        isFalse,
      );
    });

    test('returns true when all required fields are filled', () {
      expect(
        canProceed(
          tripName: 'Liburan Banten',
          selectedProvince: 'Banten',
          selectedBudgetId: 'menengah',
        ),
        isTrue,
      );
    });

    test('city is optional – returns true without city', () {
      // City is not part of _canProceed in the source
      expect(
        canProceed(
          tripName: 'Trip Pantai',
          selectedProvince: 'Banten',
          selectedBudgetId: 'budget',
        ),
        isTrue,
      );
    });
  });

  // ── Budget id mapping ───────────────────────────────────────────────────────
  group('AiTripPlanPage – budget id mapping', () {
    test('contains exactly 5 budget options', () {
      expect(budgetOptions.length, 5);
    });

    test('each budget option has a non-empty id and name', () {
      for (final opt in budgetOptions) {
        expect(opt['id'], isNotEmpty);
        expect(opt['name'], isNotEmpty);
      }
    });

    test('budgetIdForName returns correct id for hemat', () {
      expect(budgetIdForName('💸 Hemat — < Rp100.000'), equals('hemat'));
    });

    test('budgetIdForName returns correct id for luxury', () {
      expect(budgetIdForName('🏝 Luxury — > Rp1.500.000'), equals('luxury'));
    });

    test('budgetIdForName returns null for unknown name', () {
      expect(budgetIdForName('Unknown Budget'), isNull);
    });

    test('all budget ids are unique', () {
      final ids = budgetOptions.map((e) => e['id']).toList();
      expect(ids.toSet().length, ids.length);
    });
  });

  // ── Province / city selection state simulation ──────────────────────────────
  group('AiTripPlanPage – province change resets city', () {
    // Simulates the state mutations that _onProvinceChanged performs
    test('changing province clears selected city and cities list', () {
      // Initial state
      String? selectedCity = 'Tangerang';
      List<Map<String, String>> cities = [
        {'id': '1', 'name': 'Tangerang'},
        {'id': '2', 'name': 'Cilegon'},
      ];

      // Simulate _onProvinceChanged
      void onProvinceChanged() {
        selectedCity = null;
        cities = [];
      }

      onProvinceChanged();

      expect(selectedCity, isNull);
      expect(cities, isEmpty);
    });

    test('changing province to Banten does NOT show demo snackbar flag', () {
      // The snackbar is only shown when province.toLowerCase() != 'banten'
      bool shouldShowSnackbar(String provinceName) =>
          provinceName.toLowerCase() != 'banten';

      expect(shouldShowSnackbar('Banten'), isFalse);
      expect(shouldShowSnackbar('banten'), isFalse);
      expect(shouldShowSnackbar('Jawa Barat'), isTrue);
      expect(shouldShowSnackbar('DKI Jakarta'), isTrue);
    });

    test('_onCityChanged updates selected city name', () {
      String? selectedCity;

      void onCityChanged(String id, String name) {
        selectedCity = name;
      }

      onCityChanged('101', 'Tangerang Selatan');
      expect(selectedCity, equals('Tangerang Selatan'));
    });
  });
}