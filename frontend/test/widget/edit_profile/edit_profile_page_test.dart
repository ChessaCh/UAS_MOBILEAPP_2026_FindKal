import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:findkal/profile/edit_profile.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  group('Edit Profile Page Widget Tests', () {
    testWidgets('Renders EditProfilePage and interacts with TextFields and buttons', (WidgetTester tester) async {
      // Set up
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test User',
        'username': 'testuser123',
        'bio': 'Initial bio',
        'profile_photo': null,
      };

      await tester.pumpWidget(const MaterialApp(home: EditProfilePage()));
      await tester.pumpAndSettle();

      // Expect that text fields have initial values
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('Initial bio'), findsOneWidget);

      // Do: Enter new text in TextFields
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'New Name'); // Name field (assumes 1st is Name)
      await tester.enterText(textFields.last, 'Updated Bio'); // Bio field (assumes 2nd is Bio)
      await tester.pump();

      // Expect new texts
      expect(find.text('New Name'), findsOneWidget);
      expect(find.text('Updated Bio'), findsOneWidget);

      // Verify the existence of the Simpan button
      final saveButton = find.widgetWithText(ElevatedButton, 'Simpan');
      expect(saveButton, findsOneWidget);

      // Do: verify "Ganti Foto Profil" text
      expect(find.text('Ganti Foto Profil'), findsOneWidget);
    });
  });
}
