import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/models/edit_profile_model.dart';

void main() {
  group('Edit Profile Input Nama atau Bio Unit Tests', () {
    test('Input nama dan bio dapat disimpan di model dengan benar', () {
      // Set up
      final model = EditProfileModel(
        name: 'New Name Test',
        bio: 'New Bio Test',
      );

      // Do
      final dataMap = model.toMap();

      // Expect
      expect(model.name, 'New Name Test');
      expect(model.bio, 'New Bio Test');
      expect(dataMap['name'], 'New Name Test');
      expect(dataMap['bio'], 'New Bio Test');
    });
  });
}
