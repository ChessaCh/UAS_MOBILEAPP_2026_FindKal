import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:findkal/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('06 Menghapus foto saat ini', () {
    testWidgets('Verify tap on Hapus foto profil', (WidgetTester tester) async {
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test User',
        'profile_photo': 'http://example.com/photo.jpg', // Give a mock photo so delete option appears
      };
      
      app.main(); 
      await tester.pumpAndSettle(const Duration(seconds: 4));

      final bottomNavBarIcons = find.byType(Icon);
      await tester.tap(bottomNavBarIcons.last);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.text('Edit Profil'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byType(CircleAvatar).first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Assert Hapus option exists
      expect(find.text('Hapus foto profil'), findsOneWidget);

      await tester.tap(find.text('Hapus foto profil'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Bottom sheet should be gone
      expect(find.text('Hapus foto profil'), findsNothing);
    });
  });
}
