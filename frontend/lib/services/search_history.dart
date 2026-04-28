class SearchHistory {
  static final List<String> _history = [];

  static List<String> get items => List.unmodifiable(_history);

  static void add(String query) {
    final q = query.trim();
    if (q.isEmpty) return;
    _history.remove(q);
    _history.insert(0, q);
    if (_history.length > 10) _history.removeLast();
  }

  static void remove(String query) => _history.remove(query);

  static void clear() => _history.clear();
}
