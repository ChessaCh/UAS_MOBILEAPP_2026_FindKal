import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:findkal/profile/edit_profile.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  group('Edit Profile Kemabli Widget Tests', () {
    testWidgets('Kembali ke halaman sebelumnya saat tombol back ditekan', (WidgetTester tester) async {
      // Set up
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: const Scaffold(body: Text('Previous Page')),
          routes: {
            '/edit': (context) => const EditProfilePage(),
          },
        ),
      );

      BuildContext context = tester.element(find.text('Previous Page'));
      Navigator.pushNamed(context, '/edit');
      await tester.pumpAndSettle();

      // Ensure we are on edit page
      expect(find.text('Edit profil'), findsOneWidget);

      // Do: tap the back button (leading icon arrow_back_ios_new)
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle();

      // Expect
      expect(find.text('Previous Page'), findsOneWidget);
      expect(find.text('Edit profil'), findsNothing);
    });
  });
}
