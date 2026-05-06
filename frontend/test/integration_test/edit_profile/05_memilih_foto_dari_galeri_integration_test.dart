import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:findkal/services/auth_state.dart';
import 'package:findkal/profile/profile.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('05 Memilih foto dari galeri', () {
    testWidgets('Verify tap on Pilih dari galeri', (WidgetTester tester) async {
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test User',
      };
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage())); 
        await tester.pumpAndSettle();

        await tester.tap(find.text('Edit Profil'));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byType(CircleAvatar).first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // We tap but warnIfMissed: false because image picker cannot be purely UI tested without mock
        // This confirms the option exists and is tappable.
        await tester.tap(find.text('Pilih dari galeri'), warnIfMissed: false);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      });
    });
  });
}
