import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/models/edit_profile_model.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  group('Edit Profile Model Unit Tests', () {
    test('hasPhoto should return correctly based on photoDeleted and existing/new photo', () {
      // Set up
      final modelWithoutPhoto = EditProfileModel(name: 'Wawanti');
      final modelWithExistingPhoto = EditProfileModel(
        name: 'Wawanti', 
        existingPhotoUrl: 'http://example.com/photo.jpg'
      );
      final modelWithDeletedPhoto = EditProfileModel(
        name: 'Wawanti', 
        existingPhotoUrl: 'http://example.com/photo.jpg', 
        photoDeleted: true
      );
      final modelWithNewPhoto = EditProfileModel(
        name: 'Wawanti', 
        newPhoto: XFile('path/to/new/photo.jpg')
      );

      // Do
      final c1 = modelWithoutPhoto.hasPhoto;
      final c2 = modelWithExistingPhoto.hasPhoto;
      final c3 = modelWithDeletedPhoto.hasPhoto;
      final c4 = modelWithNewPhoto.hasPhoto;

      // Expect
      expect(c1, false);
      expect(c2, true);
      expect(c3, false);
      expect(c4, true);
    });

    test('isDirty should return true if fields are updated', () {
      // Set up
      final modelClean = EditProfileModel(name: '');
      final modelDirtyName = EditProfileModel(name: 'Wawanti');
      final modelDirtyBio = EditProfileModel(name: '', bio: 'My bio');

      // Do
      final r1 = modelClean.isDirty;
      final r2 = modelDirtyName.isDirty;
      final r3 = modelDirtyBio.isDirty;

      // Expect
      expect(r1, false);
      expect(r2, true);
      expect(r3, true);
    });

    test('toMap formats correctly for API submission', () {
      // Set up
      final model = EditProfileModel(
        name: ' Wawanti ',
        bio: ' Love traveling ',
        photoDeleted: false,
      );

      // Do
      final dataMap = model.toMap();

      // Expect
      expect(dataMap['name'], 'Wawanti'); // Trimmed
      expect(dataMap['bio'], 'Love traveling'); // Trimmed
      expect(dataMap['deletePhoto'], false);
    });
  });
}
