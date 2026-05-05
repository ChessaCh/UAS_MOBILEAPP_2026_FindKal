import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/profile/profile.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  group('Refresh Profile Widget Tests', () {
    testWidgets('Pull to refresh triggers refresh indicator', (WidgetTester tester) async {
      // Set up
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test User',
        'username': 'testuser123',
        'bio': 'This is my dummy bio',
        'profile_photo': null,
      };

      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: ProfilePage())));
      await tester.pumpAndSettle();

      // Do
      // Find the RefreshIndicator (or scroll view) and pull down
      await tester.fling(find.byType(SingleChildScrollView), const Offset(0, 300), 1000);
      await tester.pump();

      // Expect
      // The refresh indicator should be shown
      expect(find.byType(RefreshProgressIndicator), findsOneWidget);

      // Finish the refresh animation
      await tester.pumpAndSettle();
      expect(find.byType(RefreshProgressIndicator), findsNothing);
    });
  });
}
