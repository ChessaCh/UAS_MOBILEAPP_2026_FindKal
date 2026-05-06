import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:findkal/services/auth_state.dart';
import 'package:findkal/profile/profile.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('09 Kembali ke halaman sebelumnya', () {
    testWidgets('Verify back button returns to Profile page', (WidgetTester tester) async {
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test User',
      };
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage())); 
        await tester.pumpAndSettle();

        await tester.tap(find.text('Edit Profil'));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(find.text('Edit profil'), findsWidgets); // On Edit profile page

        // Tap back button (Icons.arrow_back_ios_new)
        await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Should be back on the original Profile page, denoted by name text and lack of Edit Profil appbar
        expect(find.text('Edit Profil'), findsWidgets); // The button on the Profile screen
        expect(find.text('Edit profil'), findsNothing); // The app bar text on Edit Profile
      });
    });
  });
}
