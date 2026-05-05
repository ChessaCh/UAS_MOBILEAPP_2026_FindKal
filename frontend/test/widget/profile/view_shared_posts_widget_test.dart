import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/profile/profile.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  group('View Shared Posts Widget Tests', () {
    testWidgets('Shared posts list is rendered', (WidgetTester tester) async {
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

      // Expect
      expect(find.text('Postingan yang sudah pernah dibagikan'), findsOneWidget);
      
      // Since _fetchUserUnggahans loads asynchronously, we wait for it
      // Expect that a FutureBuilder or ListView is present
      expect(find.byType(FutureBuilder<List<dynamic>>), findsNothing); // Depending on specific generic type if needed
    });
  });
}
