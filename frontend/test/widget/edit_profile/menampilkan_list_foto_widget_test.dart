import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:findkal/profile/edit_profile.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  group('Edit Profile Menampilkan List Foto Widget Tests', () {
    testWidgets('Menampilkan list foto (bottom sheet) saat foto profile di tap', (WidgetTester tester) async {
      // Set up
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test',
      };

      await tester.pumpWidget(const MaterialApp(home: EditProfilePage()));
      await tester.pumpAndSettle();

      // Do
      await tester.tap(find.byIcon(Icons.camera_alt));
      await tester.pumpAndSettle();

      // Expect
      expect(find.byType(BottomSheet), findsOneWidget);
      expect(find.text('Pilih dari galeri'), findsOneWidget);
    });
  });
}
