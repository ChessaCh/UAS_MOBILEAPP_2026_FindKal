import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:findkal/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('09 Kembali ke halaman sebelumnya', () {
    testWidgets('Verify back button returns to Profile page', (WidgetTester tester) async {
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test User',
      };
      
      app.main(); 
      await tester.pumpAndSettle(const Duration(seconds: 4));

      final bottomNavBarIcons = find.byType(Icon);
      await tester.tap(bottomNavBarIcons.last);
      await tester.pumpAndSettle(const Duration(seconds: 2));

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
}
