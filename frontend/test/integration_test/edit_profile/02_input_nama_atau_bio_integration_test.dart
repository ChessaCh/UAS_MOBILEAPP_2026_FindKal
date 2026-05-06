import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:findkal/services/auth_state.dart';
import 'package:findkal/profile/profile.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('02 Input Nama atau Bio', () {
    testWidgets('Verify typing into name and bio fields', (WidgetTester tester) async {
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test User',
        'username': 'testuser123',
        'bio': 'My initial bio',
      };
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage())); 
        await tester.pumpAndSettle();

        await tester.tap(find.text('Edit Profil'));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        final textFields = find.byType(TextField);
        expect(textFields, findsAtLeastNWidgets(2));

        await tester.enterText(textFields.first, 'Updated Name');
        await tester.enterText(textFields.last, 'This is my updated bio');
        
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.text('Updated Name'), findsOneWidget);
        expect(find.text('This is my updated bio'), findsOneWidget);
      });
    });
  });
}
