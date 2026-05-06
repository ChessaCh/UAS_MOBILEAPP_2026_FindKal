import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:findkal/services/auth_state.dart';
import 'package:findkal/profile/profile.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('01 Menuju Halaman Edit Profil', () {
    testWidgets('Verify navigation to Edit Profile page', (WidgetTester tester) async {
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test User',
        'username': 'testuser123',
        'bio': 'My initial bio',
      };
      
      await tester.pumpWidget(const MaterialApp(home: ProfilePage())); 
      await tester.pumpAndSettle();

      expect(find.text('Test User'), findsOneWidget);

      await tester.tap(find.text('Edit Profil'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Edit profil'), findsWidgets); // AppBar title
    });
  });
}
