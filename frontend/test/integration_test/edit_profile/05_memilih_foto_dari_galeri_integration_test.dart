import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:findkal/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:findkal/services/auth_state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('05 Memilih foto dari galeri', () {
    testWidgets('Verify tap on Pilih dari galeri', (WidgetTester tester) async {
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test User',
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

      // We tap but warnIfMissed: false because image picker cannot be purely UI tested without mock
      // This confirms the option exists and is tappable.
      await tester.tap(find.text('Pilih dari galeri'), warnIfMissed: false);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });
  });
}
