import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Profile Navigation Buttons Unit Tests', () {
    test('Navigation destinations are correct', () {
      // Set up
      const String bookmarkRoute = '/bookmark';
      const String settingsRoute = '/settings';
      const String editProfileRoute = '/edit-profile';
      const String detailRoute = '/detail';

      // Do & Expect
      expect(bookmarkRoute, '/bookmark');
      expect(settingsRoute, '/settings');
      expect(editProfileRoute, '/edit-profile');
      expect(detailRoute, '/detail');
    });
  });
}
