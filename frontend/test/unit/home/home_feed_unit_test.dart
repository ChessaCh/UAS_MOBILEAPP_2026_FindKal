import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Unit tests — Feed Unggahan feature
// Covers: _fetchUnggahans grouping & filtering, average rating calculation,
// image path selection, post count aggregation.
// Tester: Irsyad
// ---------------------------------------------------------------------------

class FakeUnggahan {
  final int id;
  final String placeName;
  final String usernameHandle;
  final String imagePath;
  final int rating;

  const FakeUnggahan({
    required this.id,
    required this.placeName,
    required this.usernameHandle,
    this.imagePath = '',
    this.rating = 4,
  });
}

class PlaceSummary {
  final String placeName;
  final String imagePath;
  final int postCount;
  final double averageRating;

  const PlaceSummary({
    required this.placeName,
    required this.imagePath,
    required this.postCount,
    required this.averageRating,
  });
}

Map<String, List<FakeUnggahan>> groupByPlace(List<FakeUnggahan> all) {
  final grouped = <String, List<FakeUnggahan>>{};
  for (final u in all) {
    grouped.putIfAbsent(u.placeName, () => []).add(u);
  }
  return grouped;
}

List<PlaceSummary> buildFeed(List<FakeUnggahan> all, String currentUsername) {
  final grouped = groupByPlace(all);
  return grouped.entries
      .where(
        (e) => e.value.any(
          (u) => u.usernameHandle.replaceAll('@', '') != currentUsername,
        ),
      )
      .map((e) {
        final list = e.value;
        final avgRating = list.fold(0, (s, u) => s + u.rating) / list.length;
        final firstImage = list
            .map((u) => u.imagePath)
            .firstWhere((p) => p.isNotEmpty, orElse: () => '');
        return PlaceSummary(
          placeName: e.key,
          imagePath: firstImage,
          postCount: list.length,
          averageRating: avgRating,
        );
      })
      .toList();
}

void main() {
  // ── groupByPlace ────────────────────────────────────────────────────────────
  group('HomePage – groupByPlace', () {
    test('groups posts with the same placeName together', () {
      final posts = [
        const FakeUnggahan(id: 1, placeName: 'Pantai Anyer', usernameHandle: '@alice'),
        const FakeUnggahan(id: 2, placeName: 'Pantai Anyer', usernameHandle: '@bob'),
        const FakeUnggahan(id: 3, placeName: 'Kawah Ratu', usernameHandle: '@carol'),
      ];

      final result = groupByPlace(posts);
      expect(result['Pantai Anyer']!.length, 2);
      expect(result['Kawah Ratu']!.length, 1);
    });

    test('returns empty map for empty input', () {
      expect(groupByPlace([]), isEmpty);
    });

    test('single post creates a single-item group', () {
      final posts = [
        const FakeUnggahan(id: 1, placeName: 'Curug Cigamea', usernameHandle: '@dave'),
      ];
      final result = groupByPlace(posts);
      expect(result.keys.length, 1);
      expect(result['Curug Cigamea']!.length, 1);
    });

    test('each unique placeName becomes a separate key', () {
      final posts = [
        const FakeUnggahan(id: 1, placeName: 'A', usernameHandle: '@x'),
        const FakeUnggahan(id: 2, placeName: 'B', usernameHandle: '@y'),
        const FakeUnggahan(id: 3, placeName: 'C', usernameHandle: '@z'),
      ];
      expect(groupByPlace(posts).keys.length, 3);
    });
  });

  // ── buildFeed – other-user filter ───────────────────────────────────────────
  group('HomePage – buildFeed (other-user filter)', () {
    test('excludes place where only the current user posted', () {
      final posts = [
        const FakeUnggahan(id: 1, placeName: 'My Place', usernameHandle: '@arji'),
      ];
      expect(buildFeed(posts, 'arji'), isEmpty);
    });

    test('includes place where another user also posted', () {
      final posts = [
        const FakeUnggahan(id: 1, placeName: 'Pantai Anyer', usernameHandle: '@arji'),
        const FakeUnggahan(id: 2, placeName: 'Pantai Anyer', usernameHandle: '@bob'),
      ];
      final feed = buildFeed(posts, 'arji');
      expect(feed.length, 1);
      expect(feed.first.placeName, 'Pantai Anyer');
    });

    test('includes place posted entirely by other users', () {
      final posts = [
        const FakeUnggahan(id: 1, placeName: 'Kawah Ratu', usernameHandle: '@carol'),
      ];
      expect(buildFeed(posts, 'arji').length, 1);
    });

    test('filters strip the @ prefix before comparing usernames', () {
      final posts = [
        const FakeUnggahan(id: 1, placeName: 'Solo Post', usernameHandle: '@arji'),
      ];
      expect(buildFeed(posts, 'arji'), isEmpty);
    });

    test('returns empty feed when all posts are by current user', () {
      final posts = [
        const FakeUnggahan(id: 1, placeName: 'Place A', usernameHandle: '@arji'),
        const FakeUnggahan(id: 2, placeName: 'Place B', usernameHandle: '@arji'),
      ];
      expect(buildFeed(posts, 'arji'), isEmpty);
    });

    test('returns empty feed for empty post list', () {
      expect(buildFeed([], 'arji'), isEmpty);
    });
  });

  // ── buildFeed – average rating ──────────────────────────────────────────────
  group('HomePage – buildFeed (average rating)', () {
    test('single post averageRating equals its own rating', () {
      final posts = [
        const FakeUnggahan(id: 1, placeName: 'Pantai', usernameHandle: '@bob', rating: 5),
      ];
      expect(buildFeed(posts, 'arji').first.averageRating, closeTo(5.0, 0.001));
    });

    test('averageRating is the mean of all grouped ratings', () {
      final posts = [
        const FakeUnggahan(id: 1, placeName: 'Pantai', usernameHandle: '@bob', rating: 4),
        const FakeUnggahan(id: 2, placeName: 'Pantai', usernameHandle: '@carol', rating: 2),
      ];
      // (4 + 2) / 2 = 3.0
      expect(buildFeed(posts, 'arji').first.averageRating, closeTo(3.0, 0.001));
    });

    test('postCount reflects total number of posts in the group', () {
      final posts = List.generate(
        4,
        (i) => FakeUnggahan(id: i, placeName: 'Pantai', usernameHandle: '@user$i', rating: 3),
      );
      expect(buildFeed(posts, 'nobody').first.postCount, 4);
    });
  });

  // ── buildFeed – first image pick ─────────────────────────────────────────────
  group('HomePage – buildFeed (imagePath)', () {
    test('imagePath is empty string when no post has an image', () {
      final posts = [
        const FakeUnggahan(id: 1, placeName: 'Pantai', usernameHandle: '@bob', imagePath: ''),
      ];
      expect(buildFeed(posts, 'arji').first.imagePath, '');
    });

    test('picks first non-empty imagePath from the group', () {
      final posts = [
        const FakeUnggahan(id: 1, placeName: 'Pantai', usernameHandle: '@bob', imagePath: ''),
        const FakeUnggahan(
          id: 2,
          placeName: 'Pantai',
          usernameHandle: '@carol',
          imagePath: 'https://img.com/photo.jpg',
        ),
      ];
      expect(buildFeed(posts, 'arji').first.imagePath, 'https://img.com/photo.jpg');
    });
  });
}
