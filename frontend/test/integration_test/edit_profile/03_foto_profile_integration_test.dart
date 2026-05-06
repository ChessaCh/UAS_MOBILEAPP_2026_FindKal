import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:findkal/services/auth_state.dart';
import 'package:findkal/profile/profile.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('03 Foto Profile', () {
    testWidgets('Verify profile photo widget exists on edit page', (WidgetTester tester) async {
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

        // There should be a CircleAvatar representing the photo
        expect(find.byType(CircleAvatar), findsWidgets);
        
        // There should be a camera icon
        expect(find.byIcon(Icons.camera_alt), findsOneWidget);
      });
    });
  });
}
