import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:findkal/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('04 Lihat postingan yang sudah pernah dibagikan', () {
    testWidgets('Verify presence of user posts section', (WidgetTester tester) async {
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test Profile User',
        'username': 'testprofile',
      };
      
      await tester.pumpWidget(const MaterialApp(home: ProfilePage())); 
      await tester.pumpAndSettle();

      // Scroll down to make sure posts section is visible if needed
      final scrollable = find.byType(SingleChildScrollView).first;
      await tester.drag(scrollable, const Offset(0.0, -300.0));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Postingan Section Title
      expect(find.text('Postingan yang sudah pernah dibagikan'), findsOneWidget);

      // The grid might fail to fetch or succeed (showing 0 posts). 
      // Verify "Belum ada postingan." state or check for image grid in cases where mocked API returns list.
      // Usually defaults to empty state if no backend running.
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final noPostText = find.text('Belum ada postingan.');
      final gridView = find.byType(GridView);
      
      // If the grid views items it will show, otherwise the empty placeholder will show
      expect(noPostText.evaluate().isNotEmpty || gridView.evaluate().isNotEmpty, isTrue);
    });
  });
}
