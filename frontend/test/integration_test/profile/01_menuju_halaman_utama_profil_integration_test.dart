import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:findkal/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('01 Menuju Halaman Utama Profil', () {
    testWidgets('Verify navigation to main Profile page', (WidgetTester tester) async {
      // Mock logged-in user
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test Profile User',
        'username': 'testprofile',
        'bio': 'Test bio profile',
      };
      
      await tester.pumpWidget(const MaterialApp(home: ProfilePage())); 
      await tester.pumpAndSettle();

      // Verify user's name and bio are visible on the Profile page
      expect(find.text('Test Profile User'), findsOneWidget);
      expect(find.text('@testprofile'), findsOneWidget);
      expect(find.text('Test bio profile'), findsOneWidget);
    });
  });
}
