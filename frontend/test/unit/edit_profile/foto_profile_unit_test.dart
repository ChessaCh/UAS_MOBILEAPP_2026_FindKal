import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/models/edit_profile_model.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  group('Edit Profile Foto Profile Unit Tests', () {
    test('Model dapat menyimpan state foto profile saat ini', () {
      // Set up
      final model = EditProfileModel(
        name: 'User',
        existingPhotoUrl: 'http://example.com/foto.jpg',
      );

      // Do
      final hasPhoto = model.hasPhoto;

      // Expect
      expect(model.existingPhotoUrl, 'http://example.com/foto.jpg');
      expect(hasPhoto, true);
    });
  });
}
