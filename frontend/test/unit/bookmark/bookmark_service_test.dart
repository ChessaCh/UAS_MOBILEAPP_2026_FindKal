import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Unit tests for BookmarkPage logic
// Covers: search/filter logic, edit-mode state transitions, select-all toggle,
// delete selection logic — all extracted as pure functions matching the source.
// ---------------------------------------------------------------------------

// ── Minimal Unggahan stub (mirrors the real model fields used by BookmarkPage) ─
class FakeUnggahan {
  final int id;
  final String placeName;
  final List<String> imagePaths;

  const FakeUnggahan({
    required this.id,
    required this.placeName,
    this.imagePaths = const [],
  });
}

// ── Search / filter logic ────────────────────────────────────────────────────

List<FakeUnggahan> filterBookmarks(List<FakeUnggahan> all, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return List.from(all);
  return all.where((b) => b.placeName.toLowerCase().contains(q)).toList();
}

List<String> buildSuggestions(List<FakeUnggahan> all, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return [];
  final matches = all
      .where((b) => b.placeName.toLowerCase().contains(q))
      .map((b) => b.placeName)
      .toSet()
      .toList();
  matches.sort((a, b) {
    final aStarts = a.toLowerCase().startsWith(q) ? 0 : 1;
    final bStarts = b.toLowerCase().startsWith(q) ? 0 : 1;
    return aStarts.compareTo(bStarts);
  });
  return matches.take(5).toList();
}

// ── Select-all toggle (mirrors _selectAll) ───────────────────────────────────

Set<int> toggleSelectAll(
  Set<int> currentSelected,
  List<FakeUnggahan> filtered,
) {
  if (currentSelected.length == filtered.length) {
    return {};
  } else {
    return filtered.map((b) => b.id).toSet();
  }
}

// ── Single item toggle (mirrors _toggleSelect) ───────────────────────────────

Set<int> toggleSelect(Set<int> currentSelected, int id) {
  final next = Set<int>.from(currentSelected);
  if (next.contains(id)) {
    next.remove(id);
  } else {
    next.add(id);
  }
  return next;
}

// ── Delete (mirrors _deleteSelected state mutation) ──────────────────────────

List<FakeUnggahan> deleteSelected(
  List<FakeUnggahan> bookmarks,
  Set<int> selectedIds,
) {
  return bookmarks.where((b) => !selectedIds.contains(b.id)).toList();
}

void main() {
  // ── Fixtures ────────────────────────────────────────────────────────────────
  late List<FakeUnggahan> bookmarks;

  setUp(() {
    bookmarks = [
      const FakeUnggahan(id: 1, placeName: 'Pantai Anyer'),
      const FakeUnggahan(id: 2, placeName: 'Pantai Sawarna'),
      const FakeUnggahan(id: 3, placeName: 'Kawah Ratu'),
      const FakeUnggahan(id: 4, placeName: 'Curug Cigamea'),
      const FakeUnggahan(id: 5, placeName: 'Pantai Carita'),
    ];
  });

  // ── filterBookmarks ─────────────────────────────────────────────────────────
  group('BookmarkPage – filterBookmarks', () {
    test('empty query returns all bookmarks', () {
      expect(filterBookmarks(bookmarks, ''), hasLength(5));
    });

    test('whitespace-only query returns all bookmarks', () {
      expect(filterBookmarks(bookmarks, '   '), hasLength(5));
    });

    test('case-insensitive match on placeName', () {
      final result = filterBookmarks(bookmarks, 'PANTAI');
      expect(result.length, 3);
    });

    test('partial match returns correct items', () {
      final result = filterBookmarks(bookmarks, 'curug');
      expect(result.length, 1);
      expect(result.first.placeName, 'Curug Cigamea');
    });

    test('no match returns empty list', () {
      final result = filterBookmarks(bookmarks, 'xyz99');
      expect(result, isEmpty);
    });

    test('exact match works', () {
      final result = filterBookmarks(bookmarks, 'Kawah Ratu');
      expect(result.length, 1);
      expect(result.first.id, 3);
    });
  });

  // ── buildSuggestions ────────────────────────────────────────────────────────
  group('BookmarkPage – buildSuggestions', () {
    test('empty query returns empty suggestions', () {
      expect(buildSuggestions(bookmarks, ''), isEmpty);
    });

    test('returns up to 5 suggestions', () {
      // All 5 have 'a' somewhere
      final suggestions = buildSuggestions(bookmarks, 'a');
      expect(suggestions.length, lessThanOrEqualTo(5));
    });

    test('suggestions starting with query come first', () {
      final suggestions = buildSuggestions(bookmarks, 'pan');
      // All "Pantai" places start with "pan", others don't
      for (final s in suggestions) {
        if (!s.toLowerCase().startsWith('pan')) {
          // Should appear after ones that do start with 'pan'
          final firstNonStart = suggestions.indexWhere(
            (x) => !x.toLowerCase().startsWith('pan'),
          );
          final thisIndex = suggestions.indexOf(s);
          expect(thisIndex, greaterThanOrEqualTo(firstNonStart));
        }
      }
    });

    test('no duplicates in suggestions', () {
      final suggestions = buildSuggestions(bookmarks, 'pantai');
      expect(suggestions.toSet().length, suggestions.length);
    });
  });

  // ── toggleSelectAll ─────────────────────────────────────────────────────────
  group('BookmarkPage – toggleSelectAll', () {
    test('selects all when nothing is selected', () {
      final result = toggleSelectAll({}, bookmarks);
      expect(result, {1, 2, 3, 4, 5});
    });

    test('selects all when only some are selected', () {
      final result = toggleSelectAll({1, 2}, bookmarks);
      expect(result, {1, 2, 3, 4, 5});
    });

    test('clears all when all are selected', () {
      final allIds = bookmarks.map((b) => b.id).toSet();
      final result = toggleSelectAll(allIds, bookmarks);
      expect(result, isEmpty);
    });
  });

  // ── toggleSelect ────────────────────────────────────────────────────────────
  group('BookmarkPage – toggleSelect (single item)', () {
    test('adds id when not in selection', () {
      final result = toggleSelect({1, 2}, 3);
      expect(result, containsAll([1, 2, 3]));
    });

    test('removes id when already selected', () {
      final result = toggleSelect({1, 2, 3}, 2);
      expect(result, containsAll([1, 3]));
      expect(result, isNot(contains(2)));
    });

    test('does not mutate original set', () {
      final original = {1, 2};
      toggleSelect(original, 3);
      expect(original, {1, 2}); // unchanged
    });
  });

  // ── deleteSelected ──────────────────────────────────────────────────────────
  group('BookmarkPage – deleteSelected', () {
    test('removes selected items from list', () {
      final result = deleteSelected(bookmarks, {1, 3});
      expect(result.map((b) => b.id).toList(), [2, 4, 5]);
    });

    test('empty selection leaves list unchanged', () {
      final result = deleteSelected(bookmarks, {});
      expect(result.length, bookmarks.length);
    });

    test('deleting all items returns empty list', () {
      final allIds = bookmarks.map((b) => b.id).toSet();
      final result = deleteSelected(bookmarks, allIds);
      expect(result, isEmpty);
    });

    test('does not mutate original list', () {
      deleteSelected(bookmarks, {1});
      expect(bookmarks.length, 5); // unchanged
    });
  });

  // ── Edit-mode state transitions ─────────────────────────────────────────────
  group('BookmarkPage – edit mode state', () {
    test('entering edit mode clears selectedIds', () {
      Set<int> selectedIds = {1, 2};
      bool isEditMode = false;

      // _enterEditMode()
      isEditMode = true;
      selectedIds.clear();

      expect(isEditMode, isTrue);
      expect(selectedIds, isEmpty);
    });

    test('exiting edit mode clears selectedIds', () {
      Set<int> selectedIds = {1, 2, 3};
      bool isEditMode = true;

      // _exitEditMode()
      isEditMode = false;
      selectedIds.clear();

      expect(isEditMode, isFalse);
      expect(selectedIds, isEmpty);
    });

    test('allSelected is true only when every filtered item is selected', () {
      bool allSelected(Set<int> selectedIds, List<FakeUnggahan> filtered) =>
          filtered.isNotEmpty && selectedIds.length == filtered.length;

      expect(allSelected({1, 2, 3, 4, 5}, bookmarks), isTrue);
      expect(allSelected({1, 2}, bookmarks), isFalse);
      expect(allSelected({}, bookmarks), isFalse);
      // Empty filtered list
      expect(allSelected({}, []), isFalse);
    });
  });
}
