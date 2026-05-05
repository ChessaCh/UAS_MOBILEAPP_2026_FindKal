import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/models/edit_profile_model.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  group('Edit Profile Memilih Foto Dari Galeri Unit Tests', () {
    test('Model dapat menerima file gambar baru dari galeri', () {
      // Set up
      final XFile mockFile = XFile('dummy_path/image.jpg');
      final model = EditProfileModel(
        name: 'User',
        newPhoto: mockFile,
      );

      // Do
      final hasPhoto = model.hasPhoto;
      final fileData = model.newPhoto;

      // Expect
      expect(hasPhoto, true);
      expect(fileData?.path, 'dummy_path/image.jpg');
    });
  });
}
