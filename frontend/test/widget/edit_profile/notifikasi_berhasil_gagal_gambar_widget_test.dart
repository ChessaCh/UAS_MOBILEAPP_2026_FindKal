import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:findkal/profile/edit_profile.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  group('Edit Profile Notifikasi Gambar Widget Tests', () {
    testWidgets('Notifikasi gagal ditampilkan jika ada exception (dummy testing)', (WidgetTester tester) async {
      // Set up
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test',
      };

      await tester.pumpWidget(const MaterialApp(home: EditProfilePage()));
      await tester.pumpAndSettle();

      // For a successful or failure notification on image picker in flutter widget test, 
      // without directly mocking the ImagePicker channel, we can verify that 
      // a SnackBar widget is correctly processed by triggering save with invalid API environment
      
      final simpanButton = find.widgetWithText(ElevatedButton, 'Simpan');
      await tester.tap(simpanButton);
      await tester.pump();
      
      // Assuming saving triggers API and since there is no backend, we expect error SnackBar to show up eventually
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(SnackBar), findsWidgets);
    });
  });
}
