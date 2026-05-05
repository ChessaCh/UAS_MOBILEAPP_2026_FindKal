import 'package:flutter_test/flutter_test.dart';

void main() {
  group('View Shared Posts Unit Tests', () {
    test('Filtering shared posts by user', () {
      // Set up
      final List<Map<String, dynamic>> allPosts = [
        {'id': 1, 'username': 'testuser123', 'content': 'Post 1'},
        {'id': 2, 'username': 'otheruser', 'content': 'Post 2'},
        {'id': 3, 'username': 'testuser123', 'content': 'Post 3'},
      ];

      // Do
      final userPosts = allPosts.where((post) => post['username'] == 'testuser123').toList();

      // Expect
      expect(userPosts.length, 2);
      expect(userPosts[0]['id'], 1);
      expect(userPosts[1]['id'], 3);
    });
  });
}
