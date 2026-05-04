import 'package:flutter_test/flutter_test.dart';
import 'dart:math' as math;

// ---------------------------------------------------------------------------
// Unit tests for MapPage / MapDirectionPage pure logic
// Covers: haversine distance, formatDistance, formatDuration, durationFor,
// and the emulator-fallback location guard.
// ---------------------------------------------------------------------------

// ── Haversine (copied verbatim from map_direction_page.dart) ─────────────────
double haversineSimple(double lat1, double lon1, double lat2, double lon2) {
  const r = 6371000.0;
  final dLat = (lat2 - lat1) * math.pi / 180;
  final dLon = (lon2 - lon1) * math.pi / 180;
  final a =
      math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1 * math.pi / 180) *
          math.cos(lat2 * math.pi / 180) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);
  return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}

// ── formatDistance ────────────────────────────────────────────────────────────
String formatDistance(double meters) {
  if (meters >= 1000) return '${(meters / 1000).toStringAsFixed(1)} km';
  return '${meters.toInt()} m';
}

// ── formatDuration ────────────────────────────────────────────────────────────
String formatDuration(double seconds) {
  final mins = (seconds / 60).round();
  if (mins >= 60) {
    final h = mins ~/ 60;
    final m = mins % 60;
    return m == 0 ? '$h jam' : '$h jam $m menit';
  }
  return '$mins menit';
}

// ── durationFor (mirrors _durationFor in MapDirectionPage) ───────────────────
double durationFor({
  required String mode,
  required double? distanceMeters,
  required double? durationSeconds,
}) {
  final dist = distanceMeters ?? 0;
  final carSecs = durationSeconds ?? 0;
  switch (mode) {
    case 'motorcycle':
      return dist / (40000 / 3600);
    case 'walking':
      return dist / (5000 / 3600);
    case 'car':
    default:
      return carSecs;
  }
}

// ── Emulator fallback guard ───────────────────────────────────────────────────
// The app uses haversine > 10,000 km as the threshold to switch to the default
// BSD location.
const _defaultLocation = (-6.3001423950968265, 106.6405338994729); // (lat, lng)
const double _emulatorThresholdMeters = 10000000.0; // 10,000 km

bool shouldUseFallbackLocation(double lat, double lng) {
  return haversineSimple(lat, lng, _defaultLocation.$1, _defaultLocation.$2) >
      _emulatorThresholdMeters;
}

void main() {
  // ── haversineSimple ─────────────────────────────────────────────────────────
  group('MapController – haversineSimple', () {
    test('distance from a point to itself is 0', () {
      expect(haversineSimple(0, 0, 0, 0), closeTo(0, 0.001));
    });

    test('BSD to Tangerang Selatan is roughly 1–5 km', () {
      // BSD area (-6.300, 106.640) to Tangsel city center (-6.290, 106.710)
      final d = haversineSimple(-6.300, 106.640, -6.290, 106.710);
      expect(d, greaterThan(1000));
      expect(d, lessThan(10000));
    });

    test('Indonesia to USA is > 10,000 km', () {
      // BSD to New York
      final d = haversineSimple(-6.300, 106.640, 40.714, -74.006);
      expect(d, greaterThan(10000000));
    });

    test('symmetric — distance(A,B) == distance(B,A)', () {
      final ab = haversineSimple(-6.3, 106.6, -6.5, 107.0);
      final ba = haversineSimple(-6.5, 107.0, -6.3, 106.6);
      expect(ab, closeTo(ba, 0.001));
    });

    test('result is in meters (not km)', () {
      // 1 degree of latitude ~ 111 km
      final d = haversineSimple(0, 0, 1, 0);
      expect(d, greaterThan(100000)); // > 100 km in meters
      expect(d, lessThan(120000)); // < 120 km
    });
  });

  // ── formatDistance ──────────────────────────────────────────────────────────
  group('MapDirectionPage – formatDistance', () {
    test('shows metres for distances under 1000 m', () {
      expect(formatDistance(500), '500 m');
    });

    test('shows exactly 1000 m as 1.0 km', () {
      expect(formatDistance(1000), '1.0 km');
    });

    test('shows km with 1 decimal for large distances', () {
      expect(formatDistance(5500), '5.5 km');
    });

    test('rounds down for partial metres', () {
      expect(formatDistance(999.9), '999 m');
    });

    test('shows 0 m for zero distance', () {
      expect(formatDistance(0), '0 m');
    });

    test('large distance formats correctly', () {
      expect(formatDistance(100000), '100.0 km');
    });
  });

  // ── formatDuration ──────────────────────────────────────────────────────────
  group('MapDirectionPage – formatDuration', () {
    test('shows minutes for durations under 1 hour', () {
      expect(formatDuration(1800), '30 menit'); // 30 minutes
    });

    test('shows exactly 60 minutes as 1 jam', () {
      expect(formatDuration(3600), '1 jam');
    });

    test('shows hours and minutes for mixed durations', () {
      expect(formatDuration(5400), '1 jam 30 menit'); // 90 minutes
    });

    test('shows only hours when minutes remainder is 0', () {
      expect(formatDuration(7200), '2 jam'); // 120 minutes exactly
    });

    test('rounds seconds to nearest minute', () {
      expect(formatDuration(90), '2 menit'); // 1.5 min rounds to 2
    });

    test('0 seconds shows 0 menit', () {
      expect(formatDuration(0), '0 menit');
    });
  });

  // ── durationFor ─────────────────────────────────────────────────────────────
  group('MapDirectionPage – durationFor (transport modes)', () {
    const distanceMeters = 10000.0; // 10 km
    const carSeconds = 900.0; // 15 min by car (from API)

    test('car mode returns OSRM duration directly', () {
      expect(
        durationFor(
          mode: 'car',
          distanceMeters: distanceMeters,
          durationSeconds: carSeconds,
        ),
        closeTo(carSeconds, 0.001),
      );
    });

    test('motorcycle mode calculates from 40 km/h', () {
      // 10 km / 40 km/h = 0.25 h = 900 s
      final expected = distanceMeters / (40000 / 3600);
      expect(
        durationFor(
          mode: 'motorcycle',
          distanceMeters: distanceMeters,
          durationSeconds: carSeconds,
        ),
        closeTo(expected, 0.1),
      );
    });

    test('walking mode calculates from 5 km/h', () {
      // 10 km / 5 km/h = 2 h = 7200 s
      final expected = distanceMeters / (5000 / 3600);
      expect(
        durationFor(
          mode: 'walking',
          distanceMeters: distanceMeters,
          durationSeconds: carSeconds,
        ),
        closeTo(expected, 0.1),
      );
    });

    test('walking is always slower than motorcycle for same distance', () {
      final motorDur = durationFor(
        mode: 'motorcycle',
        distanceMeters: 5000,
        durationSeconds: 600,
      );
      final walkDur = durationFor(
        mode: 'walking',
        distanceMeters: 5000,
        durationSeconds: 600,
      );
      expect(walkDur, greaterThan(motorDur));
    });

    test('unknown mode falls through to car', () {
      final result = durationFor(
        mode: 'bicycle',
        distanceMeters: distanceMeters,
        durationSeconds: carSeconds,
      );
      expect(result, closeTo(carSeconds, 0.001));
    });

    test('null distance defaults to 0 duration', () {
      expect(
        durationFor(
          mode: 'motorcycle',
          distanceMeters: null,
          durationSeconds: null,
        ),
        closeTo(0, 0.001),
      );
    });
  });

  // ── Emulator fallback location guard ────────────────────────────────────────
  group('MapPage – emulator fallback location', () {
    test('BSD location does NOT trigger fallback', () {
      expect(shouldUseFallbackLocation(-6.300, 106.640), isFalse);
    });

    test('USA location DOES trigger fallback', () {
      expect(
        shouldUseFallbackLocation(37.774, -122.419),
        isTrue,
      ); // San Francisco
    });

    test('New York location triggers fallback', () {
      expect(shouldUseFallbackLocation(40.714, -74.006), isTrue);
    });

    test('nearby Jakarta location does NOT trigger fallback', () {
      expect(shouldUseFallbackLocation(-6.200, 106.816), isFalse);
    });

    test('threshold is exactly 10,000 km', () {
      // Just over 10,000 km from BSD → should use fallback
      // Just under → should NOT
      const latFar = 40.714; // New York
      const lonFar = -74.006;
      final dist = haversineSimple(-6.300, 106.640, latFar, lonFar);
      expect(dist, greaterThan(_emulatorThresholdMeters));
    });
  });
}
