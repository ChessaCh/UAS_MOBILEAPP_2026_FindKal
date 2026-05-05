import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:findkal/profile/edit_profile.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  group('Edit Profile Memilih Foto Dari Galeri Widget Tests', () {
    testWidgets('Pilih dari galeri di tap pada bottom sheet', (WidgetTester tester) async {
      // Set up
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test',
      };

      await tester.pumpWidget(const MaterialApp(home: EditProfilePage()));
      await tester.pumpAndSettle();

      // Do - Open bottom sheet 
      await tester.tap(find.byIcon(Icons.camera_alt));
      await tester.pumpAndSettle();

      // Expect bottom sheet item
      final galleryOption = find.text('Pilih dari galeri');
      expect(galleryOption, findsOneWidget);

      // Do - Tap gallery option (the image_picker will be invoked, but in a test environment without a mock it might just close the sheet or throw, we just make sure it resolves)
      await tester.tap(galleryOption);
      await tester.pumpAndSettle();
      
      expect(find.byType(BottomSheet), findsNothing);
    });
  });
}
