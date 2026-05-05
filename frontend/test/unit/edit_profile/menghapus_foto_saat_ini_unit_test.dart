import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/models/edit_profile_model.dart';

void main() {
  group('Edit Profile Menghapus Foto Saat Ini Unit Tests', () {
    test('State photoDeleted benar ketika foto dihapus', () {
      // Set up
      final model = EditProfileModel(
        name: 'User',
        existingPhotoUrl: 'http://example.com/foto.jpg',
        photoDeleted: true,
      );

      // Do
      final hasPhoto = model.hasPhoto;
      final dataMap = model.toMap();

      // Expect
      expect(hasPhoto, false);
      expect(model.photoDeleted, true);
      expect(dataMap['deletePhoto'], true);
    });
  });
}
