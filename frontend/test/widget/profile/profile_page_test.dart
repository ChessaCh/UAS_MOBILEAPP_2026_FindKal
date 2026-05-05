import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:findkal/profile/profile.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  group('Profile Page Widget Tests', () {
    testWidgets('Renders ProfilePage with user data and actions', (WidgetTester tester) async {
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

      // Expect
      // Verify Name and Username are rendered
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('@testuser123'), findsOneWidget);
      expect(find.text('This is my dummy bio'), findsOneWidget);

      // Verify the existence of the Edit Profil button
      expect(find.widgetWithText(ElevatedButton, 'Edit Profil'), findsOneWidget);

      // Verify top actions exist
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

      // Verify posts section title
      expect(find.text('Postingan yang sudah pernah dibagikan'), findsOneWidget);
    });
  });
}
