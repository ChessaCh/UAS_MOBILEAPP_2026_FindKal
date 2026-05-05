import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:findkal/profile/edit_profile.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  group('Edit Profile Button Simpan Widget Tests', () {
    testWidgets('Terdapat Button Simpan dan dapat ditekan', (WidgetTester tester) async {
      // Set up
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test',
      };

      await tester.pumpWidget(const MaterialApp(home: EditProfilePage()));
      await tester.pumpAndSettle();

      // Expect
      final simpanButton = find.widgetWithText(ElevatedButton, 'Simpan');
      expect(simpanButton, findsOneWidget);

      // Do
      await tester.tap(simpanButton);
      await tester.pump();

      // Expect loading indicator to appear since we mocked the API update process to be async
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
