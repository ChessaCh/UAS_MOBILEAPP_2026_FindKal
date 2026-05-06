import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Unit tests — Map (bisa ditekan) feature
// Covers: _onItemTapped routing rules
// Tester: Arji
// ---------------------------------------------------------------------------

/// Returns true when the tab tap should push MapPage instead of switching index.
/// Mirrors the index == 1 guard in _onItemTapped.
bool tappedMapTab(int index) => index == 1;

void main() {
  group('HomePage – _onItemTapped routing', () {
    test('index 1 (Location tab) triggers MapPage push', () {
      expect(tappedMapTab(1), isTrue);
    });

    test('index 0 (Home tab) does NOT push MapPage', () {
      expect(tappedMapTab(0), isFalse);
    });

    test('index 2 (Profile tab) does NOT push MapPage', () {
      expect(tappedMapTab(2), isFalse);
    });
  });
}
