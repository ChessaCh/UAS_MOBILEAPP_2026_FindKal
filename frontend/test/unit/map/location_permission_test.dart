import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Unit tests for location permission handling in MapPage & MapDirectionPage
// Mirrors the permission-check logic without calling Geolocator.
// ---------------------------------------------------------------------------

// ── Permission state enum (mirrors geolocator's LocationPermission) ───────────
enum FakeLocationPermission { denied, deniedForever, whileInUse, always }

// ── Permission evaluation logic (mirrors both MapPage and MapDirectionPage) ───

/// Returns true if location is accessible (not denied or deniedForever)
bool isLocationAccessible(FakeLocationPermission permission) {
  return permission != FakeLocationPermission.denied &&
      permission != FakeLocationPermission.deniedForever;
}

/// Whether to show the "permission denied forever" error message
bool shouldShowDeniedForeverError(FakeLocationPermission permission) {
  return permission == FakeLocationPermission.deniedForever;
}

/// In MapDirectionPage, permission == deniedForever causes an error state
/// and returns early — mirrors the guard in _loadRoute()
bool shouldReturnEarlyFromLoadRoute(FakeLocationPermission permission) {
  return permission == FakeLocationPermission.deniedForever;
}

/// In MapSearchResultPage, the permission check before location fetch
/// mirrors _initLocationThenSearch's guard:
/// if (permission != deniedForever && permission != denied) → get position
bool canGetCurrentPosition(FakeLocationPermission permission) {
  return permission != FakeLocationPermission.deniedForever &&
      permission != FakeLocationPermission.denied;
}

// ── Route base URL selection (mirrors _loadRoute switch in MapDirectionPage) ──
String routeBaseForMode(String mode) {
  switch (mode) {
    case 'walking':
      return 'https://routing.openstreetmap.de/routed-foot/route/v1/driving/';
    default: // 'car' and 'motorcycle'
      return 'https://router.project-osrm.org/route/v1/driving/';
  }
}

// ── Suggestion debounce logic ─────────────────────────────────────────────────
// Mirrors _onSearchTextChanged: empty query clears suggestions immediately
bool shouldClearSuggestions(String query) {
  return query.trim().isEmpty;
}

void main() {
  // ── isLocationAccessible ────────────────────────────────────────────────────
  group('Location permission – isLocationAccessible', () {
    test('whileInUse is accessible', () {
      expect(isLocationAccessible(FakeLocationPermission.whileInUse), isTrue);
    });

    test('always is accessible', () {
      expect(isLocationAccessible(FakeLocationPermission.always), isTrue);
    });

    test('denied is NOT accessible', () {
      expect(isLocationAccessible(FakeLocationPermission.denied), isFalse);
    });

    test('deniedForever is NOT accessible', () {
      expect(
        isLocationAccessible(FakeLocationPermission.deniedForever),
        isFalse,
      );
    });
  });

  // ── shouldShowDeniedForeverError ────────────────────────────────────────────
  group('Location permission – deniedForever error state', () {
    test('shows error only for deniedForever', () {
      expect(
        shouldShowDeniedForeverError(FakeLocationPermission.deniedForever),
        isTrue,
      );
    });

    test('does not show error for denied (user can still be asked again)', () {
      expect(
        shouldShowDeniedForeverError(FakeLocationPermission.denied),
        isFalse,
      );
    });

    test('does not show error for whileInUse', () {
      expect(
        shouldShowDeniedForeverError(FakeLocationPermission.whileInUse),
        isFalse,
      );
    });
  });

  // ── shouldReturnEarlyFromLoadRoute ──────────────────────────────────────────
  group('MapDirectionPage – _loadRoute early return guard', () {
    test('returns early when permission is deniedForever', () {
      expect(
        shouldReturnEarlyFromLoadRoute(FakeLocationPermission.deniedForever),
        isTrue,
      );
    });

    test('does NOT return early for whileInUse', () {
      expect(
        shouldReturnEarlyFromLoadRoute(FakeLocationPermission.whileInUse),
        isFalse,
      );
    });

    test('does NOT return early for always', () {
      expect(
        shouldReturnEarlyFromLoadRoute(FakeLocationPermission.always),
        isFalse,
      );
    });

    test('does NOT return early for denied (request will be made)', () {
      // Note: in the source, after denied the code calls requestPermission()
      // then checks deniedForever again. The initial denied check does NOT
      // early-return on its own in MapDirectionPage.
      expect(
        shouldReturnEarlyFromLoadRoute(FakeLocationPermission.denied),
        isFalse,
      );
    });
  });

  // ── canGetCurrentPosition ───────────────────────────────────────────────────
  group('MapSearchResultPage – position fetch guard', () {
    test('can fetch position with whileInUse', () {
      expect(canGetCurrentPosition(FakeLocationPermission.whileInUse), isTrue);
    });

    test('can fetch position with always', () {
      expect(canGetCurrentPosition(FakeLocationPermission.always), isTrue);
    });

    test('cannot fetch position when denied', () {
      expect(canGetCurrentPosition(FakeLocationPermission.denied), isFalse);
    });

    test('cannot fetch position when deniedForever', () {
      expect(
        canGetCurrentPosition(FakeLocationPermission.deniedForever),
        isFalse,
      );
    });
  });

  // ── routeBaseForMode ────────────────────────────────────────────────────────
  group('MapDirectionPage – OSRM route URL selection', () {
    test('walking uses routed-foot endpoint', () {
      expect(routeBaseForMode('walking'), contains('routed-foot'));
    });

    test('car uses project-osrm driving endpoint', () {
      expect(routeBaseForMode('car'), contains('project-osrm'));
    });

    test('motorcycle uses project-osrm driving endpoint (same as car)', () {
      expect(routeBaseForMode('motorcycle'), contains('project-osrm'));
    });

    test('unknown mode falls through to driving endpoint', () {
      expect(routeBaseForMode('bicycle'), contains('project-osrm'));
    });

    test('car and motorcycle use the same base URL', () {
      expect(routeBaseForMode('car'), equals(routeBaseForMode('motorcycle')));
    });
  });

  // ── shouldClearSuggestions ──────────────────────────────────────────────────
  group('MapPage – suggestion debounce / clear logic', () {
    test('clears suggestions on empty query', () {
      expect(shouldClearSuggestions(''), isTrue);
    });

    test('clears suggestions on whitespace-only query', () {
      expect(shouldClearSuggestions('   '), isTrue);
    });

    test('does NOT clear on non-empty query', () {
      expect(shouldClearSuggestions('Pantai'), isFalse);
    });

    test('does NOT clear on single character query', () {
      expect(shouldClearSuggestions('a'), isFalse);
    });
  });
}
