import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:findkal/profile/edit_profile.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  group('Edit Profile Input Widget Tests', () {
    testWidgets('Input nama dan bio dapat diisi', (WidgetTester tester) async {
      // Set up
      AuthState.currentUser = {
        'id': 1,
        'name': 'Old Name',
        'username': 'oldusername',
        'bio': 'Old bio',
      };

      await tester.pumpWidget(const MaterialApp(home: EditProfilePage()));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2)); // Name & Bio

      // Do
      await tester.enterText(textFields.first, 'New Valid Name');
      await tester.enterText(textFields.last, 'New Valid Bio');
      await tester.pump();

      // Expect
      expect(find.text('New Valid Name'), findsOneWidget);
      expect(find.text('New Valid Bio'), findsOneWidget);
    });
  });
}
