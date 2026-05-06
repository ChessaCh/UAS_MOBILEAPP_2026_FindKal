import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:findkal/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('03 Button Navigasi ke Bookmark, Settings, Edit Profil, Detail', () {
    testWidgets('Verify presence and tapability of navigation buttons on profile page', (WidgetTester tester) async {
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test Profile User',
        'username': 'testprofile',
      };
      
      await tester.pumpWidget(const MaterialApp(home: ProfilePage())); 
      await tester.pumpAndSettle();

      // Bookmark Icon button (Icons.bookmark_border)
      final bookmarkBtn = find.byIcon(Icons.bookmark_border);
      expect(bookmarkBtn, findsOneWidget);

      await tester.tap(bookmarkBtn);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Test we navigated to Bookmark and now go back
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Settings Icon button (Icons.settings_outlined)
      final settingsBtn = find.byIcon(Icons.settings_outlined);
      expect(settingsBtn, findsOneWidget);

      await tester.tap(settingsBtn);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Test we navigated to Settings and now go back
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Edit Profil Button
      final editBtn = find.text('Edit Profil');
      expect(editBtn, findsOneWidget);

      await tester.tap(editBtn);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Test we navigated to Edit Profil and now go back
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });
  });
}
