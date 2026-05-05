import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:findkal/profile/edit_profile.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  group('Edit Profile Foto Profile Widget Tests', () {
    testWidgets('Menampilkan foto profile dengan avatar', (WidgetTester tester) async {
      // Set up
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test',
      };

      await tester.pumpWidget(const MaterialApp(home: EditProfilePage()));
      await tester.pumpAndSettle();

      // Expect
      expect(find.byType(CircleAvatar), findsWidgets);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });
  });
}
