import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:findkal/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('04 Menampilkan list foto untuk foto profile', () {
    testWidgets('Verify bottom sheet shows when photo is tapped', (WidgetTester tester) async {
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test User',
        'username': 'testuser123',
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

      expect(find.text('Pilih dari galeri'), findsOneWidget);
      // Since no existing photo is given, 'Hapus foto profil' might not be presented
    });
  });
}
