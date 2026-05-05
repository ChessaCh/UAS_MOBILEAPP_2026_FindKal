import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/models/unggahan.dart';

void main() {
  group('Profile Fetch Logic Unit Tests', () {
    test('filters unggahans based on current username', () {
      // Set up
      final List<Unggahan> allUnggahans = dummyUnggahans; // from models/unggahan.dart
      final String currentUserHandle = "@wawanti001"; // matching dummy data

      // Do
      final userUnggahans = allUnggahans.where((u) => u.usernameHandle == currentUserHandle).toList();

      // Expect
      expect(userUnggahans.isNotEmpty, true);
      expect(userUnggahans.every((u) => u.usernameHandle == currentUserHandle), true);
      expect(userUnggahans.first.userName, "Wawanti");
    });
  });
}
