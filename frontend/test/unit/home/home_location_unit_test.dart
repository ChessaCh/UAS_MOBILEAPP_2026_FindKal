import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Unit tests — Lokasi GPS User feature
// Covers: _initLocation() label selection logic (explorasiLabel)
// Tester: Irsyad
// ---------------------------------------------------------------------------

/// Mirrors the ternary used to render the "Eksplorasi" label based on
/// whether location permission has been granted.
String explorasiLabel(bool locationGranted) =>
    locationGranted ? 'Eksplorasi terdekat (15 km)' : 'Eksplorasi tempat';

void main() {
  group('HomePage – explorasiLabel', () {
    test('shows radius label when location is granted', () {
      expect(explorasiLabel(true), 'Eksplorasi terdekat (15 km)');
    });

    test('shows generic label when location is not granted', () {
      expect(explorasiLabel(false), 'Eksplorasi tempat');
    });
  });
}
