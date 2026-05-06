import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:findkal/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('02 Refresh Halaman Profil', () {
    testWidgets('Verify that pull-to-refresh works on the profile page', (WidgetTester tester) async {
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test Profile User',
        'username': 'testprofile',
        'bio': 'Test bio profile',
      };
      
      await tester.pumpWidget(const MaterialApp(home: ProfilePage())); 
      await tester.pumpAndSettle();

      // Ensure we are on profile page
      expect(find.text('Test Profile User'), findsOneWidget);

      // Perform a pull down gesture to trigger RefreshIndicator on the SingleChildScrollView
      final scrollable = find.byType(SingleChildScrollView);
      expect(scrollable, findsWidgets); // Can be multiple if nested

      // Drag down from the scrollable widget center
      await tester.drag(scrollable.first, const Offset(0.0, 300.0));
      await tester.pump();
      
      // Wait for the refresh indicator to start 
      await tester.pump(const Duration(seconds: 1));
      
      // Wait for refresh to complete (API mock finishes)
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // Still on profile view after refresh
      expect(find.text('Test Profile User'), findsOneWidget);
    });
  });
}
