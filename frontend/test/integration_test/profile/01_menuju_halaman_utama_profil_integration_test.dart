import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:findkal/main.dart' as app;
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
      
      app.main(); 
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Tap on Profile tab (usually last in bottom navigation bar)
      final bottomNavBarIcons = find.byType(Icon);
      await tester.tap(bottomNavBarIcons.last);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify user's name and bio are visible on the Profile page
      expect(find.text('Test Profile User'), findsOneWidget);
      expect(find.text('@testprofile'), findsOneWidget);
      expect(find.text('Test bio profile'), findsOneWidget);
    });
  });
}
