import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:findkal/services/auth_state.dart';
import 'package:findkal/profile/profile.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('08 Button Simpan', () {
    testWidgets('Verify Simpan button exists and is tappable', (WidgetTester tester) async {
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test User',
      };
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage())); 
        await tester.pumpAndSettle();

        await tester.tap(find.text('Edit Profil'));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        final buttonFinder = find.widgetWithText(ElevatedButton, 'Simpan');
        expect(buttonFinder, findsOneWidget);

        await tester.tap(buttonFinder);
        await tester.pump();
        
        // Wait for potential snackbar on failure
        await tester.pumpAndSettle(const Duration(seconds: 3));
        
        // At this point test confirms the interaction finishes
      });
    });
  });
}
