import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Unit tests for NotificationPage pure logic
// Covers: _buildNotifications branching rules — bookmark reminder preview
// text, related-post filtering, other-user filtering, message formatting,
// and empty-state conditions.
// All helpers mirror the logic inside _NotificationPageState verbatim.
// ---------------------------------------------------------------------------

// ── Fake data types ───────────────────────────────────────────────────────────

class FakeBookmark {
  final String placeName;
  const FakeBookmark(this.placeName);
  Map<String, dynamic> toMap() => {'placeName': placeName};
}

class FakeUnggahan {
  final String placeName;
  final String usernameHandle; // stored as '@username'
  final String userName;

  const FakeUnggahan({
    required this.placeName,
    required this.usernameHandle,
    required this.userName,
  });

  Map<String, dynamic> toMap() => {
    'placeName': placeName,
    'usernameHandle': usernameHandle,
    'userName': userName,
  };
}

// ── Notification 1: bookmark reminder preview text ────────────────────────────
/// Mirrors the preview-text construction in _buildNotifications().
String buildBookmarkPreview(List<Map<String, dynamic>> bookmarks) {
  final names =
      bookmarks.take(3).map((b) => b['placeName'] as String).toList();
  return names.join(', ') +
      (bookmarks.length > 3 ? ', dan lainnya' : '');
}

/// Returns true when Notification 1 (bookmark reminder) should be shown.
bool showBookmarkReminder(List<Map<String, dynamic>> bookmarks) =>
    bookmarks.isNotEmpty;

// ── Notification 2: related posts on bookmarked places ───────────────────────
/// Filters unggahans whose placeName is in the bookmarked set.
/// Mirrors the related-posts filter in _buildNotifications().
List<Map<String, dynamic>> relatedUnggahans(
  List<Map<String, dynamic>> bookmarks,
  List<Map<String, dynamic>> allUnggahans,
) {
  final bookmarkedNames =
      bookmarks.map((b) => b['placeName'] as String).toSet();
  return allUnggahans
      .where((u) => bookmarkedNames.contains(u['placeName']))
      .toList();
}

/// Returns true when Notification 2 (new reviews on bookmarked places) should
/// be shown.
bool showRelatedReviewsNotif(
  List<Map<String, dynamic>> bookmarks,
  List<Map<String, dynamic>> allUnggahans,
) {
  if (bookmarks.isEmpty || allUnggahans.isEmpty) return false;
  return relatedUnggahans(bookmarks, allUnggahans).isNotEmpty;
}

/// Mirrors the review-count message:
/// "Ada {n} ulasan baru untuk tempat yang kamu tandai — termasuk {place}."
String buildRelatedReviewsMessage(List<Map<String, dynamic>> related) {
  return 'Ada ${related.length} ulasan baru untuk tempat yang kamu tandai '
      '— termasuk ${related.first['placeName']}.';
}

// ── Notification 3: other-user posts ─────────────────────────────────────────
/// Filters posts that do NOT belong to myUsername.
List<Map<String, dynamic>> otherUserPosts(
  List<Map<String, dynamic>> allUnggahans,
  String myUsername,
) {
  return allUnggahans
      .where(
        (u) =>
            (u['usernameHandle'] as String).replaceAll('@', '') != myUsername,
      )
      .toList();
}

/// Mirrors the single vs. multi-poster message format.
String buildOtherPostsMessage(List<Map<String, dynamic>> posts) {
  final count = posts.length;
  if (count == 1) {
    return "${posts.first['userName']} baru saja berbagi tempat baru. Yuk, cek!";
  }
  return "${posts.first['userName']} dan ${count - 1} lainnya baru saja berbagi tempat baru. Yuk, cek!";
}

// ── Empty state ───────────────────────────────────────────────────────────────
/// Returns true when no notifications can be built — mirrors the final
/// `if (items.isEmpty)` guard in _buildNotifications().
bool isEmptyState({
  required List<Map<String, dynamic>> bookmarks,
  required List<Map<String, dynamic>> allUnggahans,
  required String myUsername,
}) {
  if (showBookmarkReminder(bookmarks)) return false;
  if (showRelatedReviewsNotif(bookmarks, allUnggahans)) return false;
  if (otherUserPosts(allUnggahans, myUsername).isNotEmpty) return false;
  return true;
}

// ── _loadData early-return guard ─────────────────────────────────────────────
/// Mirrors the null-userId guard at the top of _loadData().
bool shouldLoadData(int? userId) => userId != null;

void main() {
  // ── Notification 1: bookmark reminder ───────────────────────────────────────
  group('NotificationPage – bookmark reminder (Notification 1)', () {
    test('shown when bookmarks list is non-empty', () {
      final bk = [const FakeBookmark('Pantai Anyer').toMap()];
      expect(showBookmarkReminder(bk), isTrue);
    });

    test('NOT shown when bookmarks list is empty', () {
      expect(showBookmarkReminder([]), isFalse);
    });

    test('preview shows single place name when only one bookmark', () {
      final bk = [const FakeBookmark('Pantai Anyer').toMap()];
      expect(buildBookmarkPreview(bk), 'Pantai Anyer');
    });

    test('preview joins three place names with commas', () {
      final bk = [
        const FakeBookmark('Pantai Anyer').toMap(),
        const FakeBookmark('Kawah Ratu').toMap(),
        const FakeBookmark('Curug Cigamea').toMap(),
      ];
      expect(buildBookmarkPreview(bk), 'Pantai Anyer, Kawah Ratu, Curug Cigamea');
    });

    test('preview appends "dan lainnya" when more than 3 bookmarks', () {
      final bk = [
        const FakeBookmark('A').toMap(),
        const FakeBookmark('B').toMap(),
        const FakeBookmark('C').toMap(),
        const FakeBookmark('D').toMap(),
      ];
      expect(buildBookmarkPreview(bk), contains('dan lainnya'));
    });

    test('preview only uses first 3 names even with many bookmarks', () {
      final bk = List.generate(
        6,
        (i) => FakeBookmark('Place $i').toMap(),
      );
      final preview = buildBookmarkPreview(bk);
      expect(preview, contains('Place 0'));
      expect(preview, contains('Place 1'));
      expect(preview, contains('Place 2'));
      expect(preview, isNot(contains('Place 3')));
    });
  });

  // ── Notification 2: related reviews ─────────────────────────────────────────
  group('NotificationPage – related reviews (Notification 2)', () {
    test('shown when a bookmarked place has new posts', () {
      final bk = [const FakeBookmark('Pantai Anyer').toMap()];
      final posts = [
        const FakeUnggahan(
          placeName: 'Pantai Anyer',
          usernameHandle: '@bob',
          userName: 'Bob',
        ).toMap(),
      ];
      expect(showRelatedReviewsNotif(bk, posts), isTrue);
    });

    test('NOT shown when bookmarks is empty', () {
      final posts = [
        const FakeUnggahan(
          placeName: 'Pantai Anyer',
          usernameHandle: '@bob',
          userName: 'Bob',
        ).toMap(),
      ];
      expect(showRelatedReviewsNotif([], posts), isFalse);
    });

    test('NOT shown when no unggahan matches a bookmarked place', () {
      final bk = [const FakeBookmark('Kawah Ratu').toMap()];
      final posts = [
        const FakeUnggahan(
          placeName: 'Pantai Anyer',
          usernameHandle: '@bob',
          userName: 'Bob',
        ).toMap(),
      ];
      expect(showRelatedReviewsNotif(bk, posts), isFalse);
    });

    test('relatedUnggahans returns only posts for bookmarked places', () {
      final bk = [const FakeBookmark('Kawah Ratu').toMap()];
      final posts = [
        const FakeUnggahan(
          placeName: 'Kawah Ratu',
          usernameHandle: '@alice',
          userName: 'Alice',
        ).toMap(),
        const FakeUnggahan(
          placeName: 'Pantai Anyer',
          usernameHandle: '@bob',
          userName: 'Bob',
        ).toMap(),
      ];
      final related = relatedUnggahans(bk, posts);
      expect(related.length, 1);
      expect(related.first['placeName'], 'Kawah Ratu');
    });

    test('review-count message mentions correct count and place', () {
      final related = [
        const FakeUnggahan(
          placeName: 'Kawah Ratu',
          usernameHandle: '@alice',
          userName: 'Alice',
        ).toMap(),
        const FakeUnggahan(
          placeName: 'Kawah Ratu',
          usernameHandle: '@bob',
          userName: 'Bob',
        ).toMap(),
      ];
      final msg = buildRelatedReviewsMessage(related);
      expect(msg, contains('2'));
      expect(msg, contains('Kawah Ratu'));
    });
  });

  // ── Notification 3: other-user posts ────────────────────────────────────────
  group('NotificationPage – other-user posts (Notification 3)', () {
    test('excludes posts by current user', () {
      final posts = [
        const FakeUnggahan(
          placeName: 'Pantai',
          usernameHandle: '@arji',
          userName: 'Arji',
        ).toMap(),
      ];
      expect(otherUserPosts(posts, 'arji'), isEmpty);
    });

    test('includes posts by other users', () {
      final posts = [
        const FakeUnggahan(
          placeName: 'Pantai',
          usernameHandle: '@bob',
          userName: 'Bob',
        ).toMap(),
      ];
      expect(otherUserPosts(posts, 'arji').length, 1);
    });

    test('strips @ before comparing username', () {
      final posts = [
        const FakeUnggahan(
          placeName: 'Pantai',
          usernameHandle: '@arji',
          userName: 'Arji',
        ).toMap(),
      ];
      // currentUsername has no @, handle has @ — still excluded
      expect(otherUserPosts(posts, 'arji'), isEmpty);
    });

    test('single-poster message does NOT include "lainnya"', () {
      final posts = [
        const FakeUnggahan(
          placeName: 'Pantai',
          usernameHandle: '@bob',
          userName: 'Bob',
        ).toMap(),
      ];
      final msg = buildOtherPostsMessage(posts);
      expect(msg, contains('Bob'));
      expect(msg, isNot(contains('lainnya')));
    });

    test('multi-poster message includes count minus 1 and "lainnya"', () {
      final posts = [
        const FakeUnggahan(
          placeName: 'A',
          usernameHandle: '@alice',
          userName: 'Alice',
        ).toMap(),
        const FakeUnggahan(
          placeName: 'B',
          usernameHandle: '@bob',
          userName: 'Bob',
        ).toMap(),
        const FakeUnggahan(
          placeName: 'C',
          usernameHandle: '@carol',
          userName: 'Carol',
        ).toMap(),
      ];
      final msg = buildOtherPostsMessage(posts);
      expect(msg, contains('Alice'));
      expect(msg, contains('2')); // count - 1
      expect(msg, contains('lainnya'));
    });
  });

  // ── Empty state ───────────────────────────────────────────────────────────────
  group('NotificationPage – empty state', () {
    test('empty state when no bookmarks and no unggahans', () {
      expect(
        isEmptyState(bookmarks: [], allUnggahans: [], myUsername: 'arji'),
        isTrue,
      );
    });

    test('NOT empty when there are bookmarks', () {
      expect(
        isEmptyState(
          bookmarks: [const FakeBookmark('Pantai').toMap()],
          allUnggahans: [],
          myUsername: 'arji',
        ),
        isFalse,
      );
    });

    test('NOT empty when other users have posts', () {
      expect(
        isEmptyState(
          bookmarks: [],
          allUnggahans: [
            const FakeUnggahan(
              placeName: 'Pantai',
              usernameHandle: '@bob',
              userName: 'Bob',
            ).toMap(),
          ],
          myUsername: 'arji',
        ),
        isFalse,
      );
    });

    test('empty when all posts belong to the current user', () {
      expect(
        isEmptyState(
          bookmarks: [],
          allUnggahans: [
            const FakeUnggahan(
              placeName: 'Pantai',
              usernameHandle: '@arji',
              userName: 'Arji',
            ).toMap(),
          ],
          myUsername: 'arji',
        ),
        isTrue,
      );
    });
  });

  // ── _loadData early-return guard ─────────────────────────────────────────────
  group('NotificationPage – _loadData userId guard', () {
    test('skips API calls when userId is null', () {
      expect(shouldLoadData(null), isFalse);
    });

    test('proceeds with API calls when userId is present', () {
      expect(shouldLoadData(42), isTrue);
    });
  });
}
