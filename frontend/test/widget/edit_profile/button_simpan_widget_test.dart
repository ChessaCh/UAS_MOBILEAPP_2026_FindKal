import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:network_image_mock/network_image_mock.dart';
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

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: EditProfilePage()));
        await tester.pumpAndSettle();

        // Expect
        final simpanButton = find.widgetWithText(ElevatedButton, 'Simpan');
        expect(simpanButton, findsOneWidget);

        // Do
        await tester.tap(simpanButton);
        await tester.pump(); // Start the async operation

        // Allow any immediate futures to resolve (e.g. HTTP 400 rejection in tests)
        await tester.pumpAndSettle();

        // The API call will fail due to test environment and show a SnackBar
        expect(find.byType(SnackBar), findsOneWidget);
      });
    });
  });
}
