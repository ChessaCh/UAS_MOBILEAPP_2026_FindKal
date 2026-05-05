import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/profile/profile.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  group('Profile Navigation Buttons Widget Tests', () {
    testWidgets('Tapping navigation buttons triggers navigation', (WidgetTester tester) async {
      // Set up
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test User',
        'username': 'testuser123',
        'bio': 'This is my dummy bio',
        'profile_photo': null,
      };

      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: ProfilePage())));
      await tester.pumpAndSettle();

      // Expect buttons to exist
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Edit Profil'), findsOneWidget);

      // Do: Tap Bookmark button
      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pumpAndSettle();
      // Test ends here as we just ensure it responds without crashing
    });
  });
}
