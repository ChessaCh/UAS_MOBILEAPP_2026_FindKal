import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:findkal/profile/edit_profile.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  group('Edit Profile Menghapus Foto Saat Ini Widget Tests', () {
    testWidgets('Hapus foto profil di tap pada bottom sheet jika foto tersedia', (WidgetTester tester) async {
      // Set up
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test',
        'profile_photo': 'http://dummy.url/photo.jpg'
      };

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: EditProfilePage()));
        await tester.pumpAndSettle();

        // Do - Open bottom sheet 
        await tester.tap(find.byType(CircleAvatar).first); // Tapping the avatar
        await tester.pumpAndSettle();

        // Expect bottom sheet items
        final deleteOption = find.text('Hapus foto profil');
        expect(deleteOption, findsOneWidget);

        // Do - Tap delete
        await tester.tap(deleteOption);
        await tester.pumpAndSettle();

        // Expect bottom sheet is closed
        expect(find.byType(BottomSheet), findsNothing);
      });
    });
  });
}
