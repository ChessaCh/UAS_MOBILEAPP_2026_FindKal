import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:findkal/services/auth_state.dart';
import 'package:findkal/profile/profile.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('04 Menampilkan list foto untuk foto profile', () {
    testWidgets('Verify bottom sheet shows when photo is tapped', (WidgetTester tester) async {
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test User',
        'username': 'testuser123',
      };
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage())); 
        await tester.pumpAndSettle();

        await tester.tap(find.text('Edit Profil'));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byType(CircleAvatar).first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(find.text('Pilih dari galeri'), findsOneWidget);
        // Since no existing photo is given, 'Hapus foto profil' might not be presented
      });
    });
  });
}
